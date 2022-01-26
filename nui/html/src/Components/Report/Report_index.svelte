<script lang="ts">
  import StepWizard from 'svelte-step-wizard';
  import { addToast } from 'as-toast';
  import {fade, slide} from 'svelte/transition';
  import {push} from 'svelte-spa-router';
  import {v4 as uuid4} from 'uuid';
  import {IS_VISIBLE} from '../../store/store';
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
  let Data = []
  let locationblock = false
  const sendData = () => {
    fetchNui('sendVehicleData', {Info}).then((cb) => {
      addToast("Reporte Creado con Exito","info")
    });
    setTimeout(() =>{
      push('/')
    },500)
   
  };
  const addImage =  () => {
    $IS_VISIBLE = false
    fetchNui('TakePhoto').then((cb) => {
      if (cb === null) return;
      Info.imagen.push(cb.replaceAll('"', ''));
      Info.imagen = Info.imagen
      $IS_VISIBLE = true
    });
  };
  const addClosePlayerInfo = () => {
    fetchNui('getClosesPlayerInfo').then((cb) => {
      if (cb) {
        Info.name =  cb.name.replaceAll('"', '');;
        Info.lastName =  cb.lastname.replaceAll('"', '');
        Info.citizenID =  cb.citizenid.replaceAll('"', '');
      }
    });
  };
  const addCurrentLocation = () =>{
    fetchNui('getCurrentLocation').then((cb) => {
      if (cb) {
        Info.location =  cb
        locationblock = true
      }
    });
   
  }
  const getCurrentEvidence = () =>{
    fetchNui('getEvidence').then((cb) => {
      if (cb) {
        Data = cb
      }
    });
  }
</script>
<div style="{"display:" + displayed}">


<div class="fixed-center container">

  <div tabindex="0"  class="dropdown absolute-top-right" style="position:absolute;width: 37px;
  height: 33px;background: #343441;
  box-shadow: 0px 4px 4px #000000;
  border-radius: 25px;top:3%;right:2%;">
    <ul tabindex="0" class="p-2 shadow menu dropdown-content bg-base-100 rounded-box w-52">
      <li>
        <a on:click="{addClosePlayerInfo}" class="text-center">Closest Ped Info</a>
      </li> 
      <li>
        <a  on:click="{addCurrentLocation}" >Current Location</a>
      </li>
      <li>
        <a  on:click="{getCurrentEvidence}" >Add Evidence</a>
      </li> 
    </ul>
  </div>


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
            <input bind:value={Info.name} type="text" class="inputs fixed-right text-black text-h6" />
          </div>
          <!-- 		Last Name -->
          <div class="name absolute-center" style="top:30%;">
            <div class="containers fixed-right" />
            <span class="name1 absolute-left" style:left={'2%'}>Last Name</span>
            <div class="background fixed-right" />
            <input bind:value={Info.lastName} type="text" class="inputs fixed-right text-black text-h6" />
          </div>
          <!-- 		CitizenID -->
          <div class="name absolute-center" style="top:50%;">
            <div class="containers fixed-right" />
            <span class="name1 absolute-left" style:left={'14%'}>ID</span>
            <div class="background fixed-right" />
            <input bind:value={Info.citizenID} type="text " class="inputs fixed-right text-black text-h6" />
          </div>
          <!-- 		location -->
          <div class="name absolute-center" style="top:70%;">
            <div class="containers fixed-right" />
            <span class="name1 absolute-left" style:left={'6%'}>Location</span>
            <div class="background fixed-right" />
            <input disabled="{locationblock}" bind:value={Info.location} type="text " class="inputs fixed-right text-black text-h6" />
          </div>
          <!--Vehicle Involved -->

          <div class="vehicle absolute-center" style="top:90%;">
            <div class="body fixed-right"><span class="vehicle_involved" style="top:1%;font-size:12px;">Vehicle Involved</span></div>
            <input bind:checked={Info.vehicleIsinvolved} type="checkbox" class="checkbox " />

            <input disabled={!Info.vehicleIsinvolved} bind:value={Info.vehiclePlate} type="text " class="inputs fixed-right text-center  text-black text-h6" style="width:204px;height:35px;" />
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
              <textarea bind:value={Info.information} class="rectangle_21 text-black text-h6" name="asd" id="" cols="2" rows="12" />
              <!-- <div class="rectangle_21" /> -->
              <div class="rectangle_24 scroll hide-scrollbar">
                <table class="table fit table-zebra">
                  <thead>
                    <tr>
                      <th>Type</th> 
                      <th>Location</th> 
                      <th>Label</th> 
                    </tr>
                  </thead> 
                  <tbody>
                    {#each Data as info }
                    <tr>
                      <td>{info.type}</td> 
                      <td>{info.street}</td> 
                      <td>{info.type === "blood" ? info.dnalabel : info.ammolabel}</td>
                    </tr>
                    {/each}
                  </tbody>
                </table>
              </div>
              
              <!-- <textarea bind:value={Info.evidencia} class="rectangle_24 text-black text-h6" name="asd" id="" cols="2" rows="12" /> -->
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
  :root{
    --as-toast-border: 1px solid rgba(209, 213, 219, 0.3);
--as-toast-backdrop-filter: blur(8px);
--as-toast-shadow:
  0px 1.4px 2.2px rgba(0, 0, 0, 0.028),
  0px 4.7px 7.4px rgba(0, 0, 0, 0.042),
  0px 21px 33px rgba(0, 0, 0, 0.07);
--as-toast-btn-border: none;
--as-toast-info-border-color: rgba(209, 213, 219, 0.3);
--as-toast-info-background: rgba(255, 255, 255, 0.7);
--as-toast-warn-border-color: hsl(0, 68%, 47%, 30%);
--as-toast-warn-background: hsla(0, 69%, 80%, 0.7);
  }
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
</style>
