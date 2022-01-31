<script lang="ts">
  import StepWizard from 'svelte-step-wizard';
  import {addToast} from 'as-toast';
  import {push} from 'svelte-spa-router';
  import {v4 as uuid4} from 'uuid';
  import {IS_VISIBLE} from '../../store/store';
  import {fetchNui} from '../../utils/fetchNui';
  import Fines from '../Fines/Fines_modal.svelte';
  import PolicesGet from './Report_get_polices.svelte';
  $: container = 1;
  export let params = {};
  const updateContainer = (id: number) => {
    container = id;
  };
  let open = false;
  let Info = {
    ID: uuid4(),
    name: '',
    lastName: '',
    citizenID: '',
    location: '',
    vehicleIsinvolved: false,
    vehiclePlate: '',
    information: '',
    evidencia: [],
    imagen: [],
    fines: [],
    polices: [],
    jailTime: 0,
    amount: 0,
  };
  let block = false;
  let locationblock = false;
  const sendData = () => {
    fetchNui('sendReport', {Info}).then((cb) => {
      addToast('Reporte Creado con Exito', 'info');
    });
    setTimeout(() => {
      push('/');
    }, 500);
  };

  const addImage = () => {
    $IS_VISIBLE = false;
    fetchNui('TakePhoto').then((cb) => {
      if (cb === null) return;
      Info.imagen.push(cb.replaceAll('"', ''));
      Info.imagen = Info.imagen;
      $IS_VISIBLE = true;
    });
  };
  $: if (params.Name !== null) {
    Info.name = params.Name;
    Info.lastName = params.last;
    Info.citizenID = params.CitizenID;
    block = true;
  } else {
    block = false;
  }

  const addClosePlayerInfo = () => {
    fetchNui('getClosesPlayerInfo').then((cb) => {
      if (cb) {
        Info.name = cb.name.replaceAll('"', '');
        Info.lastName = cb.lastname.replaceAll('"', '');
        Info.citizenID = cb.citizenid.replaceAll('"', '');
      }
    });
  };
  const addCurrentLocation = () => {
    fetchNui('getCurrentLocation').then((cb) => {
      if (cb) {
        Info.location = cb;
        locationblock = true;
      }
    });
  };

  fetchNui('getEvidence').then((cb) => {
    if (cb) {
      Info.evidencia = cb;
    }
  });

  const openFineModal = () => {
    open = true;
    const Div = document.getElementById('id');
    let m = new Fines({
      target: Div,
      props: {
        open: open,
        table: Info.fines,
      },
    });
    m.$on('sendFines', (fines) => {
      const Fin = fines.detail.FinesAdded;
      Info.fines = Fin;
      open = false;
    });
  };
  const deteFromArray = (id: any) => {
    Info.fines.splice(
      Info.fines.findIndex((e) => e.id === id),
      1
    );
    Info.fines = Info.fines;
  };

  $: if (Info.fines.length > 1) {
    Info.amount = Info.fines.reduce(function (acc, obj) {
      return acc + obj.amount;
    }, 0);
  }
  $: if (Info.fines.length > 1) {
    Info.jailTime = Info.fines.reduce(function (acc, obj) {
      return acc + obj.jailtime;
    }, 0);
  }

  $: if (Info.fines.length === 0) {
    Info.amount = 0;
    Info.jailTime = 0;
  }
  const getPolices = () => {
    open = true;
    const Div = document.getElementById('id');
    let m = new PolicesGet({
      target: Div,
      props: {
        open: open,
      },
    });
    m.$on('sendPolices', (fines) => {
      const Fin = fines.detail.Polices;
      Info.polices = Fin;
      open = false;
    });
  };
</script>

<div class="container fixed-center">
  <div class="body fixed-center" style="width:90%;height:85%;top:47%; background: #151415;border-radius: 10px;">
    <!-- TOP MENU -->
    <div tabindex="0" class="dropdown absolute-top-right" style="position:absolute;width: 37px;height: 33px;background: #343441;box-shadow: 0px 4px 4px #000000;border-radius: 25px;top:3%;right:2%;z-index:10;">
      <ul tabindex="0" class="p-2 shadow menu dropdown-content bg-base-100 rounded-box w-52">
        <li disabled={block}>
          <a on:click={addClosePlayerInfo} class="text-center">Closest Ped Info</a>
        </li>
        <li>
          <a on:click={addCurrentLocation}>Current Location</a>
        </li>
      </ul>
    </div>
    <!-- TOP MENU -->
    <!-- step Bar -->
    <div class="absolute-bottom" style:bottom={'1%'}>
      <ul class="w-full steps">
        <li class="step step-primary">Basic Data</li>
        <li class="step" class:step-primary={container >= 2}>Additional Info</li>
        <li class="step" class:step-primary={container >= 3}>Images</li>
        <li class="step" class:step-primary={container >= 4}>End</li>
      </ul>
    </div>
    <!-- step Bar -->
    <!-- Name -->
    <div class="infobars" style="top: 11%;width: 100%;height: 100%;position: absolute;">
      <StepWizard initialStep={1}>
        <StepWizard.Step num={1} let:nextStep>
          <div class="step-1">
            <div id="Name" class="absolute-center buttonshape" style="top: 10%;">
              <span class="text-h5 absolute-left" style="top: 17%;left: 1%;">Name</span>
              <input bind:value={Info.name} type="text" id="textname" class="text-area   absolute-right text-center text-capitalize text-black" />
            </div>
            <!-- Last Name -->
            <div id="LastName" class="absolute-center buttonshape" style="top: 25%;">
              <span class="text-h5 absolute-left" style="top: 17%;left: 1%;">Last Name</span>
              <input bind:value={Info.lastName} type="text" id="textlastname" class="text-area   absolute-right text-center text-capitalize text-black" />
            </div>
            <!-- CitizenID -->
            <div id="CitizenID" class="absolute-center buttonshape" style="top: 40%;">
              <span class="text-h5 absolute-left" style="top: 17%;left: 1%;">CitizenID</span>
              <input bind:value={Info.citizenID} type="text" id="textcitizenid" class="text-area absolute-right text-center text-uppercase text-bold text-black " />
            </div>
            <!-- Location -->
            <div id="Location" class="absolute-center buttonshape" style="top: 55%;">
              <span class="text-h5 absolute-left" style="top: 17%;left: 1%;">Location</span>
              <input disabled={locationblock} bind:value={Info.location} type="text" id="textlocation" class="text-area  absolute-right text-center text-capitalize text-black" />
            </div>
            <!-- Location -->
            <div id="Vehicle" class="absolute-center buttonshape" style="top: 70%;">
              <span class="text-h6 absolute-left" style="top: 17%;left: 1%;">Vehicle Involved</span>
              <input bind:checked={Info.vehicleIsinvolved} type="checkbox" class="checkbox " />
              <input bind:value={Info.vehiclePlate} disabled={!Info.vehicleIsinvolved} type="text" id="text-vehicle" class="text-area  absolute-right text-center text-uppercase text-black" style="width:66%" />
            </div>
            <!-- INFO BARS -->
            <div class="buttonBack absolute-bottom no-input fixed-bottom" style="left:1%;bottom:1%;" on:click={() => push('/')}>
              <span class="absolute-center text-center" style:font-size="2rem">Exit</span>
            </div>
            <div on:click={() => updateContainer(2)} on:click={nextStep} class="buttonBack absolute-bottom" style="left:74.5%;bottom:1%;">
              <span class="absolute-center text-center" style:font-size="2rem">Next</span>
            </div>
          </div>
        </StepWizard.Step>
        <StepWizard.Step num={2} let:previousStep let:nextStep>
          <div class="step-2">
            <div class="infocontainer absolute-center" style="top:-1%;">
              <!-- INFORMATION TITLE  -->
              <div
                class="infobody absolute-center"
                style="position: absolute;
              width: 491.23px;
              height: 29.77px;
              background: #343441;
              box-shadow: inset 0px 4px 4px #000000;
              border-radius: 25px;"
              >
                <span class="text-h5 text-center absolute-center text-white">Information</span>
              </div>
            </div>
            <!-- INFORMATION TEXT  -->
            <textarea bind:value={Info.information} id="" cols="2" rows="12" type="textarea" class="absolute-center areatexto text-black text-h5" />
            <!-- EVIDENCIAS -->
            <div class="evidencetab absolute-center" style:top="55%">
              <div class="overflow-x-auto fit">
                <table class="table full-width">
                  <thead>
                    <tr>
                      <th>Detail</th>
                      <th>Location</th>
                      <th>Type</th>
                      <th>Label</th>
                    </tr>
                  </thead>
                  <tbody>
                    {#each Info.evidencia as env}
                      <tr>
                        <td>
                          <div class="flex items-center space-x-3">
                            <div class="avatar">
                              <div class="w-12 h-12 mask mask-squircle">
                                <img src={env.type === 'blood' ? 'iconos/blood.png' : 'iconos/ammo.png'} style:width="42px" alt={env.type} />
                              </div>
                            </div>
                          </div>
                        </td>
                        <td>{env.street}</td>
                        <th class="text-center"> <span class="badge">{env.type === 'blood' ? env.bloodtype : env.ammotype}</span></th>
                        <th class="text-center">
                          {env.type === 'blood' ? env.dnalabel : env.ammolabel}
                        </th>
                      </tr>
                    {/each}
                  </tbody>
                  <tfoot>
                    <tr>
                      <th>Detail</th>
                      <th>Location</th>
                      <th>Type</th>
                      <th>Label</th>
                    </tr>
                  </tfoot>
                </table>
              </div>
            </div>
            <!-- INFO BARS -->
            <div on:click={() => updateContainer(1)} class="buttonBack absolute-bottom no-input fixed-bottom" style="left:1%;bottom:1%;" on:click={previousStep}>
              <span class="absolute-center text-center" style:font-size="2rem">Back</span>
            </div>
            <div on:click={() => updateContainer(3)} on:click={nextStep} class="buttonBack absolute-bottom" style="left:74.5%;bottom:1%;">
              <span class="absolute-center text-center" style:font-size="2rem">Next</span>
            </div>
          </div>
        </StepWizard.Step>
        <StepWizard.Step num={3} let:previousStep let:nextStep>
          <div class="step-3">
            <div class="infocontainer absolute-center" style="top:-1%;">
              <!-- INFORMATION TITLE  -->
              <div
                class="infobody absolute-center"
                style="position: absolute;
              width: 491.23px;
              height: 29.77px;
              background: #343441;
              box-shadow: inset 0px 4px 4px #000000;
              border-radius: 25px;"
              >
                <span class="text-h5 text-center absolute-center text-white">Take Pictures</span>
              </div>
            </div>

            <div class="imagesholder absolute-center scroll hide-scrollbar">
              <div class="full-width">
                {#each Info.imagen as img}
                  <div class="q-mt-md shadow-1">
                    <img class="q-mt-md shadow-1" src={img} alt="as" srcset="" />
                  </div>
                {/each}
              </div>
            </div>
            <div on:click="{addImage}" class="botonsito absolute-center" style="position: absolute;width: 228px;height: 37px;background: #343441;top:72%;border-radius: 10px;">
              <span class="absolute-center">Take Picture</span>
            </div>
            <div on:click={() => updateContainer(2)} class="buttonBack absolute-bottom no-input fixed-bottom" style="left:1%;bottom:1%;" on:click={previousStep}>
              <span class="absolute-center text-center" style:font-size="2rem">Back</span>
            </div>

            <div on:click={() => updateContainer(4)} on:click={nextStep} class="buttonBack absolute-bottom" style="left:74.5%;bottom:1%;">
              <span class="absolute-center text-center" style:font-size="2rem">Next</span>
            </div>
          </div>
        </StepWizard.Step>
        <StepWizard.Step num={4} let:previousStep let:nextStep>
          <div class="step-4">
            <div class="infocontainer absolute-center" style="top:-1%;">
              <!-- INFORMATION TITLE  -->
              <div
                class="infobody absolute-center"
                style="position: absolute;
              width: 491.23px;
              height: 29.77px;
              background: #343441;
              box-shadow: inset 0px 4px 4px #000000;
              border-radius: 25px;"
              >
                <span class="text-h5 text-center absolute-center text-white">Fines</span>
              </div>
            </div>

            <span on:click={openFineModal} class="absolute-center " style="position:absolute; width: 24px;left: 96%;top: 39%;"><img class="absolute-center" src="iconos/Plus.png" style="position:absolute; width: 24px;left: 97%;top: 39%;" alt="" /></span>

            <div class="finecontainer absolute-center scroll hide-scrollbar" style:top="20%">
              <div class="absolute-center fit scroll hide-scrollbar">
                <table class="table full-width table-zebra ">
                  <thead>
                    <tr>
                      <th />
                      <th>Name</th>
                      <th>Jail Time</th>
                      <th>Amount</th>
                      <th>Delete</th>
                    </tr>
                  </thead>
                  <tbody>
                    {#each Info.fines as fin}
                      <tr class="hover">
                        <th>-</th>
                        <td>{fin.label}</td>
                        <td>{fin.jailtime}</td>
                        <td>{fin.amount}</td>
                        <td><button on:click={() => deteFromArray(fin.id, fin.amount)} class="btn btn-sm">Delete</button></td>
                      </tr>
                    {/each}
                  </tbody>
                  <tfoot>
                    <tr>
                      <th>-</th>
                      <th>-</th>
                      <th>Jail Time: {Info.jailTime} Months</th>
                      <th>Amount: $ {Info.amount}</th>
                      <th>-</th>
                    </tr>
                  </tfoot>
                </table>
              </div>
            </div>

            <div class="finecontainer absolute-center" style:top="58%">
              <div class="absolute-center fit scroll hide-scrollbar">
                <table class="table full-width table-zebra ">
                  <thead>
                    <tr>
                      <th />
                      <th>Name</th>
                      <th>Last Name</th>
                      <th>CID</th>
                      <th>Rank</th>
                    </tr>
                  </thead>
                  <tbody>
                    {#each Info.polices as fin}
                      <tr class="hover">
                        <th>-</th>
                        <td>{fin.Name}</td>
                        <td>{fin.LastName}</td>
                        <td>{fin.citizenid}</td>
                        <td>{fin.Rank}</td>
                      </tr>
                    {/each}
                  </tbody>
                </table>
              </div>
            </div>

            <span on:click={getPolices} class="absolute-center " style="position:absolute; width: 24px;left: 96%;top: 77%;"><img class="absolute-center" src="iconos/Plus.png" style="position:absolute; width: 24px;left: 97%;top: 76%;" alt="" /></span>

            <div on:click={() => updateContainer(3)} class="buttonBack absolute-bottom no-input fixed-bottom" style="left:1%;bottom:1%;" on:click={previousStep}>
              <span class="absolute-center text-center" style:font-size="2rem">Back</span>
            </div>

            <div on:click={() => updateContainer(5)} on:click={nextStep} class="buttonBack absolute-bottom" style="left:74.5%;bottom:1%;">
              <span class="absolute-center text-center" style:font-size="2rem">Next</span>
            </div>
          </div>
        </StepWizard.Step>
        <StepWizard.Step num={5} let:previousStep let:nextStep>
          <div class="step-4">
            <div class="infocontainer absolute-center" style="top:-1%;">
              <!-- INFORMATION TITLE  -->
              <div class="infobody absolute-center" style="position: absolute; width: 491.23px;height: 29.77px;background: #343441;box-shadow: inset 0px 4px 4px #000000;border-radius: 25px;" >
                <span class="text-h5 text-center absolute-center text-white">End Screen</span>
              </div>
            </div>
           

            <div class="name_91_10 absolute-center" style="top: 10%;left: 23%;">
              <div class="containers_91_11"></div>
              <input disabled bind:value="{Info.name}" type="text" class="background_91_12 text-capitalize  text-h6"/>
              <div class="input_91_13"></div><span  class="name_91_14">Name</span>
            </div>

            <div class="name_91_10 absolute-center" style="top: 10%;left: 77%;">
              <div class="containers_91_11"></div>
              <input disabled bind:value="{Info.lastName}" type="text" class="background_91_12 text-capitalize  text-h6"/>
              <div class="input_91_13"></div><span  class="name_91_14">L Name</span>
            </div>


            <div class="name_91_10 absolute-center" style="top: 22%;left: 77%;">
              <div class="containers_91_11"></div>
              <input disabled bind:value="{Info.jailTime}" type="text" class="background_91_12 text-capitalize  text-h6"/>
              <div class="input_91_13"></div><span  class="name_91_14">Jail Time</span>
            </div>
            <div class="name_91_10 absolute-center" style="top: 22%;left: 23%;">
              <div class="containers_91_11"></div>
              <input name="" id="" disabled bind:value="{Info.amount}" type="text" class="background_91_12 text-capitalize text-h6"/>
              <div class="input_91_13"></div><span  class="name_91_14">Amount</span>
            </div>
            <div on:click={() => updateContainer(3)} class="buttonBack absolute-bottom no-input fixed-bottom" style="left:1%;bottom:1%;" on:click={previousStep}>
              <span class="absolute-center text-center" style:font-size="2rem">Back</span>
            </div>

            <div on:click={sendData}  class="buttonBack absolute-bottom" style="left:74.5%;bottom:1%;">
              <span class="absolute-center text-center" style:font-size="2rem">Create Report</span>
            </div>
          </div>
        </StepWizard.Step>
      </StepWizard>
    </div>
  </div>
</div>

<div id="id" />

<style>
  .name_91_10 { 
	width:361.00006103515625px;
	height:39.359039306640625px;
	position:absolute;

}
.containers_91_11 { 
	box-shadow:0px 4px 4px rgba(0, 0, 0, 1);
	background-color:rgba(25.000000409781933, 25.000000409781933, 33.00000183284283, 1);
	width:360.99993896484375px;
	height:39.3587646484375px;
	position:absolute;
	left:0px;
	top:0px;
	border-top-left-radius:5px;
	border-top-right-radius:5px;
	border-bottom-left-radius:5px;
	border-bottom-right-radius:5px;
}
.background_91_12 { 
  text-align: center;
	background-color:rgba(52.390102967619896, 52.390102967619896, 64.81249898672104, 1);
	width:261.41375732421875px;
	height:39.3587646484375px;
	position:absolute;
	left:99.58631896972656px;
	top:0px;
	border-top-left-radius:5px;
	border-top-right-radius:5px;
	border-bottom-left-radius:5px;
	border-bottom-right-radius:5px;
}
.input_91_13 { 
	box-shadow:0px 4px 4px rgba(0, 0, 0, 1);
  color: black;
	width:261.51983642578125px;
	height:37.901031494140625px;
	position:absolute;
	left:99.48011779785156px;
	top:1.4580078125px;
	border-top-left-radius:5px;
	border-top-right-radius:5px;
	border-bottom-left-radius:5px;
	border-bottom-right-radius:5px;
}
.name_91_14 { 
	color:rgba(255, 255, 255, 1);
	width:99.586181640625px;
	height:9.839691162109375px;
	position:absolute;
	left:0px;
	top:15%;
	text-align:center;
	font-size:16px;
	letter-spacing:0;
}

  .finecontainer {
    position: absolute;
    width: 897px;
    height: 194px;
    background: #343441;
    box-shadow: 0px 4px 4px #000000, inset 0px 4px 4px rgba(0, 0, 0, 0.25);
    border-radius: 10px;
  }
  .botonsito {
    box-shadow: 0px 0px 0px #000000;
  }
  .botonsito:hover {
    transition: 0.1s;
    box-shadow: 0px 4px 4px #000000;
  }
  .botonsito:active {
    transition: 0.1s;
    box-shadow: inset 0px 4px 4px #000000;
  }
  .imagesholder {
    position: absolute;
    width: 897px;
    height: 380px;
    top: 36%;
    background: #343441;
    box-shadow: 0px 4px 4px #000000, inset 0px 4px 4px rgba(0, 0, 0, 0.25);
    border-radius: 10px;
  }
  .areatexto {
    position: absolute;
    width: 814.86px;
    max-width: 814.86px;
    max-height: 121.9px;
    min-width: 814.86px;
    min-height: 121.9px;
    height: 121.9px;
    top: 14%;
    background: #ffffff;
    box-shadow: 0px 4px 4px #000000, inset 0px 4px 4px rgba(0, 0, 0, 0.25);
    box-shadow: 0px 4px 4px #000000, 0px 4px 4px rgba(0, 0, 0, 0.25);
    border-radius: 10px;
  }
  .evidencetab {
    position: absolute;
    width: 897px;
    height: 262px;
    background: #343441;
    box-shadow: 0px 4px 4px #000000, inset 0px 4px 4px rgba(0, 0, 0, 0.25);
    border-radius: 10px;
  }
  .infocontainer {
    position: absolute;
    width: 523.98px;
    height: 38.27px;
    background: #191921;
    box-shadow: 0px 4px 4px #000000;
    border-radius: 10px;
  }
  .container {
    width: 100%;
    height: 100%;
    max-width: 100%;
    max-height: 100%;
    background: #0a0a0b;
    box-shadow: 0px 4px 4px #000000, inset 0px 4px 4px rgba(255, 255, 255, 0.06);
    border-radius: 10px;
  }
  .buttonshape {
    width: 644px;
    height: 40px;
    background: #191921;
    box-shadow: 0px 4px 4px #000000;
    border-radius: 10px;
  }
  .text-area {
    position: absolute;
    width: 80%;
    height: 37.9px;
    font-size: 3rem;
    background: #ffffff;
    box-shadow: 0px 4px 4px #000000, inset 0px 4px 4px rgba(0, 0, 0, 0.25);
    border-radius: 10px;
  }
  .checkbox {
    background-color: #343441;
    width: 6%;
    height: 100%;
    position: absolute;
    left: 26%;
    top: 0px;
    border-radius: 25px;
    box-shadow: inset 0px 4px 4px #000000;
  }
  .buttonBack {
    position: absolute;
    width: 228px;
    height: 37px;
    max-width: 100%;
    max-height: 100%;
    background: #343441;
    border-radius: 25px;
  }

  .buttonBack:hover {
    box-shadow: 0px 4px 4px #000000, inset 0px 0px 0px rgba(0, 0, 0, 0.25);
  }
  .buttonBack:active {
    box-shadow: 0px 4px 4px #000000, inset 0px 4px 4px rgba(0, 0, 0, 0.25);
  }
</style>
