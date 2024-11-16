using System.Collections;
using UnityEngine;

namespace BoringCrewServices.Modules
{
    public class ModuleBCSAirbags : PartModule, IMultipleDragCube
    {
        // Fields
        [KSPField]
        public string deployAnimationName;

        [KSPField]
        public string deflateAnimationName;

        [KSPField]
        public bool reverseDeployAnimation = false;

        [KSPField]
        public float deployAnimationEnd = 1f;

        [KSPField]
        public float deflateAnimationEnd = 0f;

        [KSPField]
        public bool reverseDeflateAnimation = true;

        [KSPField]
        public bool deployAboveLand = true;

        [KSPField]
        public bool deployAboveWater = true;

        [KSPField]
        public bool autoDeflateOnLand = true;

        [KSPField]
        public bool autoDeflateOnWater = false;

        [KSPField]
        public string referenceNodeName;

        [KSPField]
        public bool referenceParentNode = false;

        [KSPField(isPersistant = true)]
        public AirbagState airbagState = AirbagState.Disarmed;

        private AttachNode referenceNode;

        [SerializeField]
        public Animation deployAnimation;

        [SerializeField]
        public Animation deflateAnimation;

        private string deflateAnimationNameGet => string.IsNullOrEmpty(deflateAnimationName) ? deployAnimationName : deflateAnimationName;

        private Coroutine altitudeCoroutine;

        private Coroutine nodeCoroutine;

        // UI
        [KSPField(isPersistant = true, guiActive = true, guiActiveEditor = true, guiName = "#BCS_DeployAltitude", guiUnits = "#autoLOC_289929")]
        [UI_FloatRange(stepIncrement = 50f, maxValue = 1500f, minValue = 50f)]
        public float deployAltitude = 650f;

        [KSPAction(guiName = "#BCS_ArmDeploy", activeEditor = true)]
        public void ArmAction(KSPActionParam param) => Arm();

        [KSPEvent(active = true, guiActiveUnfocused = true, externalToEVAOnly = true, guiActive = true, unfocusedRange = 4f, guiName = "#BCS_ArmDeploy")]
        public void Arm()
        {
            if (airbagState == AirbagState.Disarmed)
            {
                airbagState = AirbagState.Armed;
                part.stackIcon.SetIconColor(XKCDColors.LightCyan);
                Events["Arm"].active = false;
                Events["Disarm"].active = true;
                if (altitudeCoroutine == null) altitudeCoroutine = StartCoroutine(AltitudeCoroutine());
            }
        }

        [KSPAction(guiName = "#BCS_DisarmDeploy", activeEditor = true)]
        public void DisarmAction(KSPActionParam param) => Disarm();

        [KSPEvent(active = false, guiActiveUnfocused = true, externalToEVAOnly = true, guiActive = true, unfocusedRange = 4f, guiName = "#BCS_DisarmDeploy")]
        public void Disarm()
        {
            if (airbagState == AirbagState.Armed)
            {
                airbagState = AirbagState.Disarmed;
                part.stackIcon.SetIconColor(XKCDColors.White);
                Events["Arm"].active = true;
                Events["Disarm"].active = false;
                StopAltitudeCoroutine();
                StopNodeCoroutine();
            }
        }

        [KSPAction(guiName = "#BCS_DeployAirbags", activeEditor = true)]
        public void DeployAction(KSPActionParam param) => Deploy();

        [KSPEvent(active = true, guiActiveUnfocused = true, externalToEVAOnly = true, guiActive = true, unfocusedRange = 4f, guiName = "#BCS_DeployAirbags")]
        public void Deploy()
        {
            if (airbagState == AirbagState.Disarmed || airbagState == AirbagState.Armed)
            {
                airbagState = AirbagState.Deployed;
                part.stackIcon.SetIconColor(XKCDColors.RadioactiveGreen);
                Events["Arm"].active = false;
                Events["Disarm"].active = false;
                Events["Deploy"].active = false;
                Events["Deflate"].active = true;

                PlayAnimation(deployAnimation, deployAnimationName, reverseDeployAnimation ? 1 : 0, deployAnimationEnd);
            }
        }

        [KSPAction(guiName = "#BCS_DeflateAirbags", activeEditor = true)]
        public void DeflateAction(KSPActionParam param) => Deflate();

        [KSPEvent(active = false, guiActiveUnfocused = true, externalToEVAOnly = true, guiActive = true, unfocusedRange = 4f, guiName = "#BCS_DeflateAirbags")]
        public void Deflate()
        {
            if (airbagState == AirbagState.Deployed)
            {
                airbagState = AirbagState.Deflated;
                part.stackIcon.SetIconColor(XKCDColors.Red);
                Events["Arm"].active = false;
                Events["Disarm"].active = false;
                Events["Deploy"].active = false;
                Events["Deflate"].active = false;

                PlayAnimation(deflateAnimation, deflateAnimationNameGet, reverseDeflateAnimation ? 1 : 0, deflateAnimationEnd);
            }
        }

        // KSP Methods
        public override void OnStart(StartState state)
        {
            base.OnStart(state);
            SetupPartIcon();

            GameEvents.onVesselSituationChange.Add(OnStatus);

            // possibly needs to be a KSPField if there's ever multiple anims playing simultaneously?
            deployAnimation[deployAnimationName].layer = 0;
            deflateAnimation[deflateAnimationNameGet].layer = 0;

            deployAnimation[deployAnimationName].speed = 0;
            deflateAnimation[deflateAnimationNameGet].speed = 0;

            if (airbagState == AirbagState.Deployed)
            {
                deployAnimation[deployAnimationName].normalizedTime = deployAnimationEnd;
                SetDragState(1f);
            }
            else if (airbagState == AirbagState.Deflated) {
                deflateAnimation[deflateAnimationNameGet].normalizedTime = deflateAnimationEnd;
                SetDragState(1f);
            }
            else
            {
                SetDragState(0f);
            }
        }

        public override void OnActive()
        {
            base.OnActive();
            Arm();
        }

        public void OnDestroy()
        {
            StopAltitudeCoroutine();
            StopNodeCoroutine();
            GameEvents.onVesselSituationChange.Remove(OnStatus);
            referenceNode = null;
        }

        public void OnStatus(GameEvents.HostedFromToAction<Vessel, Vessel.Situations> data)
        {
            if (airbagState == AirbagState.Deployed && vessel == data.host)
            {
                if ((data.to == Vessel.Situations.LANDED && autoDeflateOnLand) || (data.to == Vessel.Situations.SPLASHED && autoDeflateOnWater)) Deflate();
            }
        }

        public override void OnLoad(ConfigNode node)
        {
            base.OnLoad(node);
            if (HighLogic.LoadedScene == GameScenes.LOADING) {
                if (string.IsNullOrEmpty(deployAnimationName)) Debug.LogError($"[{nameof(ModuleBCSAirbags)}] deployAnimationName was not set!");
                else deployAnimation = part.FindModelAnimator(deployAnimationName);
                if (deployAnimation == null) Debug.LogError($"[{nameof(ModuleBCSAirbags)}] Part: {part.partInfo?.name} does not have an animation named: {deployAnimationName}");

                if (string.IsNullOrEmpty(deflateAnimationName)) 
                {
                    #if DEBUG
                    Debug.Log($"[{nameof(ModuleBCSAirbags)}] deflateAnimationName was not set, using deploy animation");
                    #endif
                    deflateAnimation = deployAnimation;
                }
                else deflateAnimation = part.FindModelAnimator(deflateAnimationName);
                // this will print something empty in the case that its supposed to use the deploy animation and that doesn't exist, but there will already be a correct error above.
                if (deflateAnimation == null) Debug.LogError($"[{nameof(ModuleBCSAirbags)}] Part: {part.partInfo?.name} does not have an animation named: {deflateAnimationName}");
            }
        }

        public string[] GetDragCubeNames()
        {
            return new string[2] { "A", "B" };
        }

        public bool UsesProceduralDragCubes() => false;
        public bool IsMultipleCubesActive => true;

        public void AssumeDragCubePosition(string name)
        {
            if (!(name == "A"))
            {
                if (name == "B")
                {
                    deployAnimation[deployAnimationName].normalizedTime = reverseDeployAnimation ? 1 : 0;
                }
            }
            else
            {
                deployAnimation[deployAnimationName].normalizedTime = deployAnimationEnd;
            }
        }

        private void SetDragState(float b)
        {
            part.DragCubes.SetCubeWeight("A", b);
            part.DragCubes.SetCubeWeight("B", 1f - b);
        }

        // Module Methods
        private void SetupPartIcon()
        {
            part.stagingIcon = "CUSTOM";
            part.stackIcon.iconType = DefaultIcons.CUSTOM;
            part.stackIcon.customIconFilename = "BoringCrewServices/Icons/BCS_AirbagIcon";
            switch (airbagState)
            {
                case AirbagState.Deployed:
                    part.stackIcon.SetIconColor(XKCDColors.RadioactiveGreen);
                    break;
                case AirbagState.Deflated:
                    part.stackIcon.SetIconColor(XKCDColors.Red);
                    break;
                case AirbagState.Armed:
                    part.stackIcon.SetIconColor(XKCDColors.LightCyan);
                    if (altitudeCoroutine == null) altitudeCoroutine = StartCoroutine(AltitudeCoroutine());
                    break;
                default:
                    part.stackIcon.SetIconColor(XKCDColors.White);
                    break;
            }
        }

        private void StopAltitudeCoroutine()
        {
            if (altitudeCoroutine != null)
            {
                StopCoroutine(altitudeCoroutine);
                altitudeCoroutine = null;
            }
        }
        private void StopNodeCoroutine()
        {
            if (nodeCoroutine != null)
            {
                StopCoroutine(nodeCoroutine);
                nodeCoroutine = null;
            }
        }

        private bool ShouldDeploy()
        {
            var altitude = FlightGlobals.getAltitudeAtPos(base.part.transform.position, base.vessel.mainBody);
            return altitude < deployAltitude || Physics.Raycast(base.part.transform.position, -base.vessel.upAxis, deployAltitude, 32768, QueryTriggerInteraction.Ignore);
        }

        private bool NodeDetached()
        {
            if (string.IsNullOrEmpty(referenceNodeName)) return true;

            var refPart = referenceParentNode ? part.parent : part;
            if (refPart == null)
            {
                Debug.LogError($"[{nameof(ModuleBCSAirbags)}] Part: {part.partInfo?.name} does not have a parent part!");
                StopNodeCoroutine();
                return false;
            }
            if (referenceNode == null || referenceNode.id != referenceNodeName)
            {
                referenceNode = refPart.FindAttachNode(referenceNodeName);
                if (referenceNode == null)
                {
                    Debug.LogError($"[{nameof(ModuleBCSAirbags)}] Part: {refPart.partInfo?.name} does not have a node with id: {referenceNodeName}");
                    StopNodeCoroutine();
                    return false;
                }
            }

            return referenceNode.attachedPart == null;
        }

        private void PlayAnimation(Animation anim, string animationName, float start, float end)
        {
            float direction = start > end ? -1f : 1f;

            anim[animationName].normalizedTime = start;
            anim[animationName].speed = direction;

            anim.Play(animationName);
            StartCoroutine(AnimationCoroutine(anim, animationName, end));
        }

        // Coroutines
        public IEnumerator AltitudeCoroutine()
        {
            while (!ShouldDeploy()) yield return new WaitForFixedUpdate();
            part.stackIcon.SetIconColor(XKCDColors.Yellow);
            if (nodeCoroutine == null) nodeCoroutine = StartCoroutine(NodeCoroutine());
        }

        public IEnumerator NodeCoroutine()
        {
            StopAltitudeCoroutine();
            while (!NodeDetached()) yield return new WaitForFixedUpdate();

            bool isAboveWater = vessel.terrainAltitude <= 0;
            if ((isAboveWater && !deployAboveWater) || (!isAboveWater && !deployAboveLand)) Disarm();
            else Deploy();
        }

        public IEnumerator AnimationCoroutine(Animation anim, string animationName, float end)
        {
            var isForward = anim[animationName].speed > 0f;

            while (((isForward && anim[animationName].normalizedTime < end) || (!isForward && anim[animationName].normalizedTime > end)) && anim.isPlaying)
            {
                if (animationName == deployAnimationName) SetDragState(anim[animationName].normalizedTime);
                yield return null;
            }

            anim.Stop(animationName);
            #if DEBUG
            Debug.Log($"[{nameof(ModuleBCSAirbags)}] Animation Coroutine finished");
            #endif
        }
    }

    public enum AirbagState
    {
        Disarmed
      , Armed
      , Deployed
      , Deflated
    }
}
