<script lang="ts">
  import {push} from 'svelte-spa-router';
  import {fade, fly} from 'svelte/transition';
  import { fetchNui } from '../../utils/fetchNui';
  import Member_search from './Members_search.svelte';
  import Member_Vehicles from './Members_vehicles.svelte';
  import {Vehicles} from "../../store/store"
  $: SearchName = '';
  let openModal = false;
  let Name= "";
  let LastName= "";
  let JobName= "";
  let Rank= "";
  $Vehicles.length = 0
  const searchData = () => {
    $Vehicles.length = 0
    openModal = true;
    const Div = document.getElementById('id');
    fetchNui('getPlayerSearch', {SearchName}).then((cb) => {
      if (cb) {
        let m = new Member_search({
          target: Div,
          props: {
            open: openModal,
            players: cb,
          },
        });
        m.$on('playerSelected', (data) => {
          const Dato = data.detail.data
          Name = Dato.Name.replaceAll('"', '');
          LastName = Dato.LastName.replaceAll('"', '');
          JobName = Dato.JobName.replaceAll('"', '');
          Rank = Dato.Rank.replaceAll('"', '');
          $Vehicles = Dato.Vehicles
          openModal = false;
        });
        m.$on("playerClosed",() =>{
          openModal = false;
        })
      }
    });
  };
  const addClosePlayerInfo = () => {
    fetchNui('getClosesPlayerInfo').then((cb) => {
      if (cb) {
        $Vehicles.length = 0
        Name =  cb.name.replaceAll('"', '');;
        LastName =  cb.lastname.replaceAll('"', '');;
        JobName = cb.Job.replaceAll('"', '');;
        Rank = cb.Rank.replaceAll('"', '');
        $Vehicles = cb.Vehicles
      }
    });
  };

  const showVehicleData = (data:[]) =>{
    openModal = true;
    const Div = document.getElementById('id');
    let m = new Member_Vehicles({
      target:Div,
      props:{
        open:openModal,
        vehicles:data,
      }
    })
    m.$on('playerSelected', () => {
         
          openModal = false;
        });
  }
</script>

<div class="background fit fixed-center " transition:fade={{duration: 100}}>
  <div class="bodycenter fixed-bottom">
    <span
      ><input bind:value={SearchName} type="text" class="fixed-top searchbar text-center text-black" name="fixed-top" style="left:27%;top:5%;" id="" />
      <div class="btn-group" style="left: 63%;top: 4%;position: absolute;">
        <button on:click={searchData} class="btn btn-active" disabled={SearchName.length <= 2 ? true : false}>Search</button>
        <div class="dropdown dropdown-bottom">
          <button class="btn" tabindex="0">
            <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" class="inline-block w-4 stroke-current">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 12h.01M12 12h.01M19 12h.01M6 12a1 1 0 11-2 0 1 1 0 012 0zm7 0a1 1 0 11-2 0 1 1 0 012 0zm7 0a1 1 0 11-2 0 1 1 0 012 0z" />
            </svg>
          </button>
          <ul tabindex="0" class="p-2 shadow menu dropdown-content bg-base-100 rounded-box w-52 text-center">
            <li>
              <a on:click="{addClosePlayerInfo}" class="text-center">Closest Ped Info</a>
            </li>
            <li>
              <a class="text-center">Get Location</a>
            </li>
          </ul>
        </div>
      </div>

    </span>

    <div class="Container">
      <div class="Name datos" style="top:18%;left:2%">
        <div class="datosLegacy absolute-right" > 
          <p class="text-center absolute-center text-h5" >
           {Name}
          </p>
        </div>
        <p class="absolute-left text-h6" style="top:28%;left:3%;">Name</p>
      </div>

      <div class="Name datos " style="top:32%;left:2%">
         <div class="datosLegacy absolute-right" > 
          <p class="text-center absolute-center text-h5" >
           {LastName}
          </p>
        </div>
        <p class="absolute-left  ellipsis" style="top:28%;left:3%;">Last Name</p>
      </div>

      <div class="Name datos " style="top:18%;right:2%">
         <div class="datosLegacy absolute-right" > 
          <p class="text-center absolute-center text-h5 text-uppercase" >
           {JobName}
          </p>
        </div>
        <p class="absolute-left text-h6" style="top:28%;left:3%;">Job</p>
      </div>

      <div class="Name datos " style="top:32%;right:2%">
         <div class="datosLegacy absolute-right" > 
          <p class="text-center absolute-center text-h5" >
           {Rank}
          </p>
        </div>
        <p class="absolute-left text-h6" style="top:28%;left:3%;">Rank</p>
      </div>
      
      <div class="absolute-left" style="top:52%;left:2%">
        <p
          class="text-center"
          style="top: -8%;right:-206%;position: relative;">
          Vehicles
        </p>
        <div class="Vehicles VandH absolute-left hide-scrollbar"  >
          <table class="table fit table-zebra text-center text-subtitle1" >
            <thead>
              <tr>
                <th>Name</th> 
                <th>Plate</th> 
              </tr>
            </thead> 
            <tbody>
              {#each $Vehicles as veh}
              <tr on:click="{() => showVehicleData(veh)}">
                <td>{veh.vehicle}</td> 
                <td>{veh.plate}</td> 
              </tr>
            {/each}
            </tbody>
          </table>
       
        </div>
      </div>
      <div class="absolute-right " style="top:47%;right:2%" >
        <p
        class="text-center" style="top: 2%;left:0%;position: relative;">
        Houses
      </p>
        <div class="Vehicles VandH hide-scrollbar" />
      </div>

      <div class="Casos absolute-bottom" style="position: absolute;      width: 664px;      height: 138px;left:17%;">
        <div class="box" style="position: absolute;width: 664px;height: 111px;background: #191921; box-shadow: 0px 4px 4px #000000, inset 0px 4px 4px #000000;
        border-radius: 10px;">

        </div>
        <p class="absolute-center text-h6" style="position:absolute;top:-7%;">
          Casos
        </p>
      </div>

    </div>
  </div>
  <div class="navbar mb-2 shadow-lg bg-neutral text-neutral-content rounded-box">
    <div class="px-2 mx-2 navbar-start">
      <span class="text-lg font-bold"> SEARCH APP </span>
    </div>
    <div class="px-2 mx-2 navbar-center lg:flex">
      <div class="flex items-stretch">
        <button on:click={() => push('/')} class="btn btn-ghost btn-sm rounded-btn"> Home </button>
        <button class="btn btn-ghost btn-sm rounded-btn"> Profile </button>
        <button class="btn btn-ghost btn-sm rounded-btn"> About </button>
      </div>
    </div>
    <!-- <div class="navbar-end">
      <button class="btn btn-square btn-ghost">
        <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" class="inline-block w-6 h-6 stroke-current">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 17h5l-1.405-1.405A2.032 2.032 0 0118 14.158V11a6.002 6.002 0 00-4-5.659V5a2 2 0 10-4 0v.341C7.67 6.165 6 8.388 6 11v3.159c0 .538-.214 1.055-.595 1.436L4 17h5m6 0v1a3 3 0 11-6 0v-1m6 0H9" />
        </svg>
      </button>
      <button  class="btn btn-square btn-ghost">
        <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" class="inline-block w-6 h-6 stroke-current">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z" />
        </svg>
      </button>
    </div> -->

  </div>

  <div id="id" />
</div>

<style>
.Vehicles{
  overflow-y: scroll;
}

  .searchbar {
    position: absolute;
    width: 348px;
    height: 34px;

    background: #ffffff;
    box-shadow: 0px 4px 4px #000000, inset 0px 4px 4px rgba(0, 0, 0, 0.25);
    border-radius: 24px;
  }
  .background {
    border-radius: 10px;
    box-shadow: 4px 4px 4px rgba(0, 0, 0, 0.6);
    background: #000000;
  }
  .bodycenter {
    position: absolute;

    background: #0c0c0f;
    border-radius: 10px;
    width: 100%;
    height: 91%;
    box-shadow: 4px 4px 4px rgba(0, 0, 0, 0.6);
  }

  .datos {
    position: absolute;
    width: 315px;
    height: 64px;
    background: #191921;
    box-shadow: 0px 4px 4px #000000;
    border-radius: 10px;
  }
  .datosLegacy {
    position: absolute;
    width: 228.1px;
    height: 64px;

    background: #343441;
    box-shadow: inset 0px 4px 4px #000000;
    border-radius: 10px;
  }
  .VandH {
    width: 315px;
    height: 111px;
    background: #191921;
    box-shadow: 0px 4px 4px #000000, inset 0px 4px 4px #000000;
    border-radius: 10px;
  }
</style>
