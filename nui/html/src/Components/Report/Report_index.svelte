<script lang="ts">
  import StepWizard from 'svelte-step-wizard';
  import {fade, fly, slide} from 'svelte/transition';
  import {push} from 'svelte-spa-router';
  import {v4 as uuid4} from 'uuid';
  import {ImagesReport, IS_VISIBLE} from '../../store/store';
  import {fetchNui} from '../../utils/fetchNui';
  $: container = 1;
  const updateContainer = (id: number) => {
    container = id;
  };
  let displayed= "block"
  const Info = {
    ID: uuid4(),
    name: '',
    lastName: '',
    citizenID: '',
    location: '',
    vehicleIsinvolved: false,
    vehiclePlate: '',
    information: '',
    evidencia: '',
    imagen: []
  };
  // let name = ""
  // let lastName= ""
  // let citizenID= ""
  // let location= ""
  // let vehicleIsinvolved = false
  // let vehiclePlate= ""

  // let information = ""
  // let evidencia = ""

  const sendData = () => {
    fetchNui('sendVehicleData', {Info}).then((cb) => {
      console.log('susses!');
    });
    
  };
  const addImage = async () => {
    $IS_VISIBLE = false
    fetchNui('TakePhoto').then((cb) => {
      if (cb === null) return;
      Info.imagen.push(cb.replaceAll('"', ''));
      Info.imagen = Info.imagen
      $IS_VISIBLE = true
    });
  };
</script>
<div style="{"display:" + displayed}">


<div class="fixed-center container">
  <div class="absolute-bottom" style:bottom={'11%'}>
    <ul class="w-full steps">
      <li class="step step-primary">Basic Data</li>
      <li class="step" class:step-primary={container >= 2}>Additional Info</li>
      <li class="step" class:step-primary={container > 2}>End</li>
    </ul>
  </div>

  <div class="bodyshape absolute-center">
    <StepWizard initialStep={1}>
      <StepWizard.Step num={1} let:nextStep>
        <div in:fade out:slide>
          <!--Name -->
          <div class="name absolute-center" style="top:10%;">
            <div class="containers fixed-right" />
            <span class="name1 absolute-left" style:left={'6%'}>Name</span>
            <div class="background fixed-right" />
            <input bind:value={Info.name} type="text" class="inputs fixed-right" />
          </div>
          <!-- 		Last Name -->
          <div class="name absolute-center" style="top:30%;">
            <div class="containers fixed-right" />
            <span class="name1 absolute-left" style:left={'2%'}>Last Name</span>
            <div class="background fixed-right" />
            <input bind:value={Info.lastName} type="text" class="inputs fixed-right" />
          </div>
          <!-- 		CitizenID -->
          <div class="name absolute-center" style="top:50%;">
            <div class="containers fixed-right" />
            <span class="name1 absolute-left" style:left={'14%'}>ID</span>
            <div class="background fixed-right" />
            <input bind:value={Info.citizenID} type="text " class="inputs fixed-right" />
          </div>
          <!-- 		location -->
          <div class="name absolute-center" style="top:70%;">
            <div class="containers fixed-right" />
            <span class="name1 absolute-left" style:left={'6%'}>Location</span>
            <div class="background fixed-right" />
            <input bind:value={Info.location} type="text " class="inputs fixed-right" />
          </div>
          <!--Vehicle Involved -->

          <div class="vehicle absolute-center" style="top:90%;">
            <div class="body fixed-right"><span class="vehicle_involved" style="top:1%;font-size:12px;">Vehicle Involved</span></div>
            <input bind:checked={Info.vehicleIsinvolved} type="checkbox" class="checkbox" />

            <input disabled={!Info.vehicleIsinvolved} bind:value={Info.vehiclePlate} type="text " class="inputs fixed-right text-center text-uppercase" style="width:204px;height:35px;" />
          </div>
        </div>
        <div class="buttonBack no-input fixed-bottom" on:click={() => push('/')}>
          <span class="absolute-center text-center" style:font-size="2rem">Exit</span>
        </div>
        <div on:click={() => updateContainer(2)} on:click={nextStep} class="buttonNext fixed-bottom">
          <span class="absolute-center text-center" style:font-size="2rem">Next</span>
        </div>
      </StepWizard.Step>
      <!--2 Place -->
      <StepWizard.Step num={2} let:previousStep let:nextStep>
        <div in:fade out:slide>
          <div class="group_11">
            <div class="bodyapp" />
            <div class="id">
              <div class="rectangle_19" />
              <div class="rectangle_20" />
              <span class="information">Information</span>
              <div class="rectangle_22" />
              <div class="rectangle_23" />
              <div class="rectangle_25" />
              <span class="evidencia">Evidencia</span>
              <textarea bind:value={Info.information} class="rectangle_21" name="asd" id="" cols="2" rows="12" />
              <!-- <div class="rectangle_21" /> -->
              <textarea bind:value={Info.evidencia} class="rectangle_24" name="asd" id="" cols="2" rows="12" />
            </div>
          </div>
        </div>
        <div class="buttonBack fixed-bottom" on:click={() => updateContainer(1)} on:click={previousStep}>
          <span class="absolute-center text-center" style:font-size="2rem">Back</span>
        </div>
        <div class="buttonNext fixed-bottom" on:click={() => updateContainer(3)} on:click={nextStep}>
          <span class="absolute-center text-center" style:font-size="2rem">Next</span>
        </div>
      </StepWizard.Step>
      <StepWizard.Step num={3} let:previousStep>
        <div in:fade out:slide>
          <div class="id_60_164 absolute-top">
            <div class="rectangle_19_60_165 absolute-top">
              <div class="rectangle_20_60_166 absolute-center">
                <span class="imagenes_60_167 absolute-center">Imagenes</span>
              </div>
            </div>
            <div
              class="absolute-center scroll hide-scrollbar"
              style="position: absolute;width: 80%;
            top: 59%;
            left: 45%;
            height: 81%;
            background: rgb(52, 52, 65);
            box-shadow: rgb(0, 0, 0) 0px 4px 4px inset;
            border-radius: 25px;"
            >
              <div class="full-width">
                {#each Info.imagen as img}
                  <div class="q-mt-md shadow-1">
                    <img class="q-mt-md shadow-1" src={img} alt="as" srcset="" />
                  </div>
                {/each}
              </div>
            </div>
          </div>
          <div on:click={addImage} class="buttonBack1 fixed-bottom">
            <span class="absolute-center text-center" style:font-size="1.5rem">Add Image</span>
          </div>
          <div class="buttonBack fixed-bottom" on:click={() => updateContainer(2)} on:click={previousStep}>
            <span class="absolute-center text-center" style:font-size="2rem">Back</span>
          </div>
          <div class="buttonNext fixed-bottom" on:click={() => updateContainer(3)} on:click={sendData}>
            <span class="absolute-center text-center" style:font-size="2rem">Finish</span>
          </div>
        </div>
      </StepWizard.Step>
    </StepWizard>
  </div>
</div>
</div>
<style>
  .container {
    position: absolute;
    width: 557px;
    height: 485px;
    max-width: 100%;
    max-height: 100%;
    background: #0a0a0b;
    box-shadow: 0px 4px 4px #000000, inset 0px 4px 4px rgba(255, 255, 255, 0.06);
    border-radius: 50px;
  }
  .bodyshape {
    position: absolute;
    width: 461px;
    height: 348px;
    top: 38.5%;
    max-width: 100%;
    max-height: 100%;

    background: #151415;
    box-shadow: 0px 4px 4px #000000, inset 0px 4px 4px rgba(255, 255, 255, 0.06);
    border-radius: 50px;
  }
  .buttonBack {
    position: absolute;
    width: 228px;
    height: 37px;
    bottom: -33%;
    left: 4%;
    max-width: 100%;
    max-height: 100%;
    background: #343441;

    border-radius: 25px;
  }
  .buttonBack1 {
    position: absolute;
    width: 228px;
    height: 37px;
    left: 25%;
    bottom: 1%;
    max-width: 100%;
    max-height: 100%;
    background: #343441;

    border-radius: 25px;
  }
  .buttonBack1:hover {
    box-shadow: 0px 4px 4px #000000, inset 0px 0px 0px rgba(0, 0, 0, 0.25);
  }
  .buttonBack1:active {
    box-shadow: 0px 4px 4px #000000, inset 0px 4px 4px rgba(0, 0, 0, 0.25);
  }
  .buttonBack:hover {
    box-shadow: 0px 4px 4px #000000, inset 0px 0px 0px rgba(0, 0, 0, 0.25);
  }
  .buttonBack:active {
    box-shadow: 0px 4px 4px #000000, inset 0px 4px 4px rgba(0, 0, 0, 0.25);
  }
  .buttonNext {
    position: absolute;
    width: 228px;
    height: 37px;
    bottom: -33%;
    left: 55.5%;
    max-width: 100%;
    max-height: 100%;
    background: #343441;
    border-radius: 25px;
  }
  .buttonNext:hover {
    box-shadow: 0px 4px 4px #000000, inset 0px 0px 0px rgba(0, 0, 0, 0.25);
  }
  .buttonNext:active {
    box-shadow: 0px 4px 4px #000000, inset 0px 4px 4px rgba(0, 0, 0, 0.25);
  }

  .name {
    width: 352px;
    height: 27px;
    position: absolute;
    color: rgba(255, 255, 255, 1);

    font-family: Poppins;
    text-align: center;
    font-size: 16px;
    letter-spacing: 0;
  }
  .containers {
    box-shadow: 0px 4px 4px rgba(0, 0, 0, 1);
    background-color: rgba(25.000000409781933, 25.000000409781933, 33.00000183284283, 1);
    width: 352px;
    height: 27px;
    position: absolute;
    border-top-left-radius: 25px;
    border-top-right-radius: 25px;
    border-bottom-left-radius: 25px;
    border-bottom-right-radius: 25px;
  }
  .background {
    background-color: rgba(52.390102967619896, 52.390102967619896, 64.81249898672104, 1);
    width: 254.8965606689453px;
    height: 27px;
    position: absolute;

    border-top-left-radius: 25px;
    border-top-right-radius: 25px;
    border-bottom-left-radius: 25px;
    border-bottom-right-radius: 25px;
  }
  .inputs {
    text-align: center;
    text-transform: capitalize;
    box-shadow: 0px 4px 4px #000000, inset 0px 4px 4px rgba(0, 0, 0, 0.25);
    background-color: rgba(255, 255, 255, 1);
    width: 255px;
    height: 26px;
    position: absolute;
    color: black;
    border-top-left-radius: 24px;
    border-top-right-radius: 24px;
    border-bottom-left-radius: 24px;
    border-bottom-right-radius: 24px;
  }
  .vehicle {
    width: 352px;
    height: 36px;
    position: absolute;
  }
  .body {
    box-shadow: 0px 4px 4px rgba(0, 0, 0, 1);
    background-color: rgba(25.000000409781933, 25.000000409781933, 33.00000183284283, 1);
    width: 352px;
    height: 36px;
    position: absolute;
    left: 0px;
    top: 0px;
    border-top-left-radius: 25px;
    border-top-right-radius: 25px;
    border-bottom-left-radius: 25px;
    border-bottom-right-radius: 25px;
  }
  .checkbox {
    background-color: rgba(52.390102967619896, 52.390102967619896, 64.81249898672104, 1);
    width: 38px;
    height: 36px;
    position: absolute;
    left: 100px;
    top: 0px;
    border-radius: 25px;
    box-shadow: inset 0px 4px 4px #000000;
  }
  .vehicle_involved {
    color: rgba(255, 255, 255, 1);
    width: 97.10344696044922px;
    height: 9px;
    position: absolute;
    left: 0px;
    top: 12.905597686767578px;
    font-family: Poppins;
    text-align: center;
    font-size: 16px;
    letter-spacing: 0;
  }

  .step-primary {
  }
  .group_11 {
    width: 471px;
    height: 344px;
    position: absolute;
  }
  .bodyapp {
    box-shadow: 0px 4px 4px rgba(0, 0, 0, 1);
    background-color: rgba(21.000000648200512, 20.000000707805157, 21.000000648200512, 1);
    width: 471px;
    height: 344px;
    position: absolute;
    left: 0px;
    top: 0px;
    border-top-left-radius: 50px;
    border-top-right-radius: 50px;
    border-bottom-left-radius: 50px;
    border-bottom-right-radius: 50px;
  }
  .id {
    width: 471px;
    height: 323px;
    position: absolute;
    left: 0px;
    top: 9px;
  }
  .rectangle_19 {
    box-shadow: 0px 4px 4px rgba(0, 0, 0, 1);
    background-color: rgba(25.000000409781933, 25.000000409781933, 33.00000183284283, 1);
    width: 272px;
    height: 27px;
    position: absolute;
    left: 99px;
    top: 0px;
    border-top-left-radius: 25px;
    border-top-right-radius: 25px;
    border-bottom-left-radius: 25px;
    border-bottom-right-radius: 25px;
  }
  .rectangle_20 {
    box-shadow: inset 0px 4px 4px #000000;
    background-color: rgba(52.390102967619896, 52.390102967619896, 64.81249898672104, 1);
    width: 255px;
    height: 21px;
    position: absolute;
    left: 108px;
    top: 3px;
    border-top-left-radius: 25px;
    border-top-right-radius: 25px;
    border-bottom-left-radius: 25px;
    border-bottom-right-radius: 25px;
  }
  .information {
    color: rgba(255, 255, 255, 1);
    width: 97.10344696044922px;
    height: 6.75px;
    position: absolute;
    left: 186px;
    top: 1px;
    font-family: Poppins;
    text-align: center;
    font-size: 16px;
    letter-spacing: 0;
  }
  .rectangle_22 {
    box-shadow: 0px 4px 4px rgba(0, 0, 0, 1);
    background-color: rgba(25.000000409781933, 25.000000409781933, 33.00000183284283, 1);
    width: 272px;
    height: 27px;
    position: absolute;
    left: 99px;
    top: 187px;
    border-top-left-radius: 25px;
    border-top-right-radius: 25px;
    border-bottom-left-radius: 25px;
    border-bottom-right-radius: 25px;
  }
  .rectangle_23 {
    box-shadow: inset 0px 4px 4px #000000;
    background-color: rgba(52.390102967619896, 52.390102967619896, 64.81249898672104, 1);
    width: 255px;
    height: 21px;
    position: absolute;
    left: 108px;
    top: 190px;
    border-top-left-radius: 25px;
    border-top-right-radius: 25px;
    border-bottom-left-radius: 25px;
    border-bottom-right-radius: 25px;
  }
  .rectangle_25 {
    background-color: rgba(52.390102967619896, 52.390102967619896, 64.81249898672104, 1);
    width: 471px;
    height: 7px;
    position: absolute;
    left: 0px;
    top: 163px;
    border-top-left-radius: 25px;
    border-top-right-radius: 25px;
    border-bottom-left-radius: 25px;
    border-bottom-right-radius: 25px;
  }
  .evidencia {
    color: rgba(255, 255, 255, 1);
    width: 97.10344696044922px;
    height: 6.75px;
    position: absolute;
    left: 186px;
    top: 189px;
    font-family: Poppins;
    text-align: center;
    font-size: 16px;
    letter-spacing: 0;
  }
  .rectangle_21 {
    box-shadow: 0px 4px 4px rgba(0, 0, 0, 1);
    background-color: rgba(255, 255, 255, 1);
    width: 423px;
    height: 86px;
    position: absolute;
    left: 24px;
    top: 50px;
    border-top-left-radius: 10px;
    border-top-right-radius: 10px;
    border-bottom-left-radius: 10px;
    border-bottom-right-radius: 10px;
  }
  .rectangle_24 {
    box-shadow: 0px 4px 4px rgba(0, 0, 0, 1);
    background-color: rgba(255, 255, 255, 1);
    width: 423px;
    height: 86px;
    position: absolute;
    left: 24px;
    top: 237px;
    border-top-left-radius: 10px;
    border-top-right-radius: 10px;
    border-bottom-left-radius: 10px;
    border-bottom-right-radius: 10px;
  }
  .id_60_164 {
    width: 508px;
    height: 302.99981689453125px;
    position: absolute;
  }
  .rectangle_19_60_165 {
    box-shadow: 0px 4px 4px rgba(0, 0, 0, 1);
    background-color: rgba(25.000000409781933, 25.000000409781933, 33.00000183284283, 1);
    width: 83%;
    height: 24.790908813476562px;
    position: absolute;
    left: 3%;
    top: 6%;
    border-top-left-radius: 25px;
    border-top-right-radius: 25px;
    border-bottom-left-radius: 25px;
    border-bottom-right-radius: 25px;
  }
  .rectangle_20_60_166 {
    box-shadow: inset 0px 4px 4px #000000;
    background-color: rgba(52.390102967619896, 52.390102967619896, 64.81249898672104, 1);
    width: 92%;
    height: 19.281818389892578px;
    position: absolute;

    border-top-left-radius: 25px;
    border-top-right-radius: 25px;
    border-bottom-left-radius: 25px;
    border-bottom-right-radius: 25px;
  }
  .imagenes_60_167 {
    color: rgba(255, 255, 255, 1);
    width: 97.10344696044922px;
    height: 6.197727203369141px;
    position: absolute;
    top: 0%;
    font-family: Poppins;
    text-align: center;
    font-size: 16px;
    letter-spacing: 0;
  }
  .group_9_61_4 {
    width: 508px;
    height: 246.99090576171875px;
    position: absolute;
  }
  .rectangle_22_60_168 {
    box-shadow: 0px 4px 4px rgba(0, 0, 0, 1);
    background-color: #191921;
    position: absolute;
    box-shadow: 0 4px 4px #000;
    height: 246.99090576171875px;
    left: 4%;
    top: 29%;
    width: 83%;
    border-top-left-radius: 25px;
    border-top-right-radius: 25px;
    border-bottom-left-radius: 25px;
    border-bottom-right-radius: 25px;
  }
  .rectangle_23_60_169 {
    background-color: #343441;
    width: 96%;
    left: 2%;
    top: 3%;
    height: 94%;
    position: absolute;
    box-shadow: inset 0px 4px 4px #000000;
    border-top-left-radius: 25px;
    border-top-right-radius: 25px;
    border-bottom-left-radius: 25px;
    border-bottom-right-radius: 25px;
  }
</style>
