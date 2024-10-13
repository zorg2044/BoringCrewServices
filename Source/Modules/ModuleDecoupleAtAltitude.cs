using System.Collections;
using UnityEngine;

namespace BoringCrewServices.Modules
{
    public class ModuleDecoupleAtAltitude : ModuleDecouple
    {
        [KSPField(isPersistant = true, guiActive = true, guiActiveEditor = true, guiName = "#BCS_JettisonAltitude", guiUnits = "#autoLOC_289929")]
        [UI_FloatRange(stepIncrement = 50f, maxValue = 1500f, minValue = 50f)]
        public float jettisonAltitude = 650f;

        [KSPAction(guiName = "#BCS_DisarmJettison", activeEditor = true)]
        public void DisarmAction(KSPActionParam param) => Disarm();

        [KSPEvent(active = false, guiActiveUnfocused = true, externalToEVAOnly = true, guiActive = true, unfocusedRange = 4f, guiName = "#BCS_DisarmJettison")]
        public void Disarm()
        {
            if (heatshieldState == HeatshieldState.Armed)
            {
                heatshieldState = HeatshieldState.Disarmed;
                part.stackIcon.SetIconColor(XKCDColors.White);
                ToggleEvents(false);
                StopAltitudeCoroutine();
            }
        }

        [KSPAction(guiName = "#BCS_ArmJettison", activeEditor = true)]
        public void ArmAction(KSPActionParam param) => Arm();

        [KSPEvent(active = true, guiActiveUnfocused = true, externalToEVAOnly = true, guiActive = true, unfocusedRange = 4f, guiName = "#BCS_ArmJettison")]
        public void Arm() => OnActive();

        public new void Decouple()
        {
            base.OnActive();
            heatshieldState = HeatshieldState.Deployed;
            ToggleEvents(false);
            Fields["jettisonAltitude"].guiActive = false;
            StopAltitudeCoroutine();
        }

        [SerializeField]
        private HeatshieldState heatshieldState = HeatshieldState.Disarmed;

        private Coroutine altitudeCoroutine;

        public override void OnStart(StartState state)
        {
            base.OnStart(state);
            SetupPartIcon();
        }

        public void OnDestroy()
        {
            StopAltitudeCoroutine();
        }

        public override void OnActive()
        {
            if (heatshieldState == HeatshieldState.Disarmed)
            {
                heatshieldState = HeatshieldState.Armed;
                part.stackIcon.SetIconColor(XKCDColors.LightCyan);
                ToggleEvents(true);
                if (altitudeCoroutine == null) altitudeCoroutine = StartCoroutine(AltitudeDecouple());
            }
        }

        private void ToggleEvents(bool armedState)
        {
            Events["Disarm"].active = armedState;
            Events["Arm"].active = !armedState;
        }

        private void SetupPartIcon()
        {
            part.stagingIcon = "CUSTOM";
            part.stackIcon.iconType = DefaultIcons.CUSTOM;
            part.stackIcon.customIconFilename = "BoringCrewServices/Icons/BCS_JettisionIcon";
        }

        private void StopAltitudeCoroutine()
        {
            if (altitudeCoroutine != null)
            {
                StopCoroutine(altitudeCoroutine);
                altitudeCoroutine = null;
            }
        }

        protected bool ShouldJetison()
        {
            var altitude = FlightGlobals.getAltitudeAtPos(base.part.transform.position, base.vessel.mainBody);
            return altitude < jettisonAltitude || Physics.Raycast(base.part.transform.position, -base.vessel.upAxis, jettisonAltitude, 32768, QueryTriggerInteraction.Ignore);
        }

        public IEnumerator AltitudeDecouple()
        {
            yield return new WaitUntil(ShouldJetison);
            Decouple();
        }
    }

    public enum HeatshieldState
    {
        Disarmed
      , Armed
      , Deployed
    }
}
