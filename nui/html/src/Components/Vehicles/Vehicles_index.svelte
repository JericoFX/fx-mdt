<script lang="ts">
  import {createEventDispatcher} from 'svelte';
  import {push} from 'svelte-spa-router';
  import {fade} from 'svelte/transition';
  import {fetchNui} from '../../utils/fetchNui';
  import Vehicle_Information from "./Vehicle_Information.svelte"
  import Colores from '../../utils/vehicle-colors';
  import {v4 as uuid4} from 'uuid';
  let open = false
  $: Vehiculo = {
    ID: uuid4(),
    Owner: '',
    Plate: "",
    Color: '',
    Brand: '',
    Category: '',
    VehicleName: '',
    Information: ""
  };
  $: Placa = Vehiculo.Plate
  const getVehicleByPlate = () => {
    console.log(Placa);
    
    fetchNui('getVehicleData', {Placa}).then((cb) => {
      if (cb) {
        console.log(JSON.stringify(cb));
        
        Vehiculo.Owner = cb.Owner;
        (Vehiculo.Color = getColorHex(cb.Color)), (Vehiculo.Brand = cb.Brand), (Vehiculo.VehicleName = cb.VehicleName), (Vehiculo.Category = cb.Category);
      }
    });
  };
  const getColorHex = (color: string): string => {
    return Colores.filter((col) => col.ID === color.toString())[0].Hex;
  };
  const addBolo = () => {
  const DIV = document.getElementById("id")
    open = true
    let m = new Vehicle_Information({
      target: DIV,
      props:{
        open: open,
        text:""
      }
    })
  m.$on("closedModal",(data) =>{
    Vehiculo.Information = data.detail.text 
    fetchNui("saveVehicleBolo",{Vehiculo}).then((cb) =>{
      push("/")
    })
  })
    //Vehiculo
  };


</script>

<div class="modal-overlay" transition:fade={{duration: 100}}>
  <div class="my-back fit" />
  <div class="container absolute-center">
    <div class="body absolute-center">
      <p class="absolute-center" style="top:8%;font-size:4rem">VEHICLES</p>
      <div class="Consiencia" style=" top: 3%;    width: 100%;    position: absolute;    height: 100%;">
        <div class="buttonbody absolute-center" style:top="15%">
          <input type="text" bind:value={Vehiculo.Plate} class="buttontext absolute-right text-center text-subtitle1 text-uppercase text-black text-bold" />
          <div on:click={getVehicleByPlate} class="icon">
            <img alt="asd" src="iconos/search.png" class="absolute-right icon" style="left: 101%;width: 33px;top: 5%;border-radius: 10px;" />
          </div>
          <div class="text">
            <span class="absolute-left customize" style:font-size="18px" style:top="25%" style:color="white" style:left="10%">Plate</span>
          </div>
        </div>
        <div class="separator absolute-center" style:top="22.5%" />
        <div class="buttonbody absolute-center" style:top="30%">
          <input type="text" bind:value={Vehiculo.Owner} class="buttontext absolute-right text-center text-black text-bold text-h6 text-capitalize" />
          <div class="text">
            <span class="absolute-left customize" style:font-size="18px" style:top="25%" style:color="white" style:left="10%">Owner</span>
          </div>
        </div>
        <div class="separator absolute-center" style:top="37.5%" />
        <div class="buttonbody absolute-center" style:top="45%">
          <div class="buttontext absolute-right text-center" style={'background:' + Vehiculo.Color + ';'} />
          <div class="text">
            <span class="absolute-left customize">Color</span>
          </div>
        </div>
        <div class="separator absolute-center" style:top="52.5%" />
        <div class="buttonbody absolute-center" style:top="60%">
          <input disabled type="text" bind:value={Vehiculo.VehicleName} class="buttontext absolute-right text-center text-capitalize text-black" />
          <div class="text">
            <span class="absolute-left" style="left:5%;color:white;top:25%;font-size: 18px;">Vehicle Name</span>
          </div>
        </div>
        <div class="separator absolute-center" style:top="67.5%" />
        <div class="buttonbody absolute-center" style:top="75%">
          <input disabled type="text" bind:value={Vehiculo.Brand} class="buttontext absolute-right text-center text-capitalize text-black" />
          <div class="text">
            <span class="absolute-left customize" style:font-size="18px" style:top="25%" style:color="white" style:left="10%">Brand</span>
          </div>
        </div>
        <div class="separator absolute-center" style:top="82.5%" />
        <div class="buttonbody absolute-center" style:top="90%">
          <input disabled type="text" bind:value={Vehiculo.Category} class="buttontext absolute-right text-center text-capitalize text-black" />
          <div class="text">
            <span class="absolute-left customize" style:font-size="18px" style:top="25%" style:color="white" style:left="10%">Category</span>
          </div>
        </div>
      </div>
    </div>
    <div on:click={addBolo} class="buttonactions absolute-bottom" style="top: 91.5%;left: 2.5%;bottom: 0.5%;">
      <span  class="absolute-center"> CREATE BOLO</span>
    </div>
    <div on:click={() => push('/')} class="buttonactions absolute-bottom" style:color="white" style:bottom="3%" style:left="71.5%">
      <span class="absolute-center"> Cerrar </span>
    </div>
  </div>
</div>
<div id="id"></div>
<style>
  .customize {
    left: 10%;
    color: white;
    top: 25%;
    font-size: 18px;
  }
  .my-back {
    background-color: rgba(255, 255, 55, 0.0001) !important;
  }
  .modal-overlay {
    z-index: 1000;
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background-color: rgba(0, 0, 0, 0.5) !important;
  }
  .container {
    width: 85%;
    height: 90%;
    max-width: 100%;
    max-height: 100%;
    background: #0a0a0b;
    border-radius: 10px;
  }
  .body {
    position: absolute;
    height: 86%;
    top: 45%;
    width: 90%;
    background: #151415;
    border-radius: 10px;
  }
  .buttonbody {
    position: absolute;
    width: 643.96px;
    height: 39.36px;
    max-width: 100%;
    max-height: 100%;
    background: #191921;
    box-shadow: 0px 4px 4px #000000;
    border-radius: 10px;
  }
  .buttontext {
    position: absolute;
    width: 466.51px;
    height: 37.9px;
    max-width: 100%;
    max-height: 100%;
    background: #ffffff;
    box-shadow: 0px 4px 4px #000000, inset 0px 4px 4px rgba(0, 0, 0, 0.25);
    border-radius: 10px;
  }
  .separator {
    position: absolute;
    width: 839px;
    height: 11px;
    max-width: 100%;
    max-height: 100%;

    background: #343441;
    box-shadow: inset 0px 4px 4px #000000;
    border-radius: 25px;
  }
  .buttonactions {
    position: absolute;
    width: 228px;
    height: 37px;
    background: #343441;
    box-shadow: 0px 0px 0px #000000;
    border-radius: 10px;
  }
  .buttonactions:hover {
    box-shadow: 0px 4px 4px #000000;
  }
  .buttonactions:active {
    box-shadow: inset 0px 4px 4px #000000;
  }
  .icon {
    filter: grayscale(30%);
    box-shadow: 0px 0px 0px #000000;
  }
  .icon:hover {
    filter: grayscale(0%);
    box-shadow: 0px 4px 4px #000000;
  }
  .icon:active {
    filter: grayscale(0%);
    box-shadow: inset 0px 4px 4px #000000;
  }
</style>
