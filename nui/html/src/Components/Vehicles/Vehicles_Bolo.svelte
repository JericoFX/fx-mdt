<script lang="ts">
  import {createEventDispatcher} from 'svelte';
  import {push} from 'svelte-spa-router';
  import {fetchNui} from '../../utils/fetchNui';
  import {Vehicles_Report,isBoss} from "../../store/store"
  import VehicleInfo from './Vehicle_Information.svelte';

  const dispatch = createEventDispatcher();
  let open = false;
  let Bolos = [];
  // fetchNui('getVehicleBolos').then((cb) => {
  //   if (cb) {
  //     console.log(JSON.stringify(cb));
  //     Bolos = cb;
  //   }
  // });

  const veh1 = (info: string) => {
    open = true;
    const Div = document.getElementById('id');
    let m = new VehicleInfo({
      target: Div,
      props: {
        open: open,
        text: info,
      },
    });
    m.$on('closedModal', () => (open = false));
    return m;
  };
</script>

<div class="container absolute-center">
  <div class="body absolute-center">
    <div class="tabtarget">
      <div class="absolute-top" style="width:100%">
        <table class="table table-zebra q-mt-sm" style="width:100%">
          <thead>
            <tr>
              <th />
              <th>Plate</th>
              <th>Vehicle</th>
              <th>Model</th>
              <th>Owner</th>
              <th>Color</th>
              <th>Report</th>
              {#if $isBoss}
               <th>Delete</th>
               {:else}
               <th />
              {/if}
             
            </tr>
          </thead>
          <tbody>
            {#each $Vehicles_Report as veh}
              <tr>
                <td>-</td>
                <td>{veh.plate}</td>
                <td>{veh.vehicle}</td>
                <td>{veh.brand}</td>
                <td>{veh.citizenid}</td>
                <td><span class=" badge full-width" style={`background:${veh.color}`} /> </td>
                <th><button on:click={() => veh1(veh.information)} class="btn btn-sm text-center">Open Report</button></th>
                  {#if $isBoss}
                <th><button on:click={() => veh1(veh.information)} class="btn btn-sm text-center">Delete</button></th>
               {:else}
               <th />
              {/if}
               
              </tr>
            {/each}
          </tbody>
        </table>
      </div>
    </div>
  </div>
  <button class="btn btn-wide btn-lg absolute-bottom" style="left:5%;bottom:0.5%;"> Add Report </button>
  <button on:click={() => push('/')} class="btn btn-wide btn-lg absolute-bottom" style="left:73%;bottom:0.5%;"> Close </button>
</div>
<div id="id" />

<style>
  .container {
    background: #0a0a0b;
    box-shadow: 0px 4px 4px #000000, inset 0px 4px 4px rgba(255, 255, 255, 0.06);
    border-radius: 10px;
    position: absolute;
    width: 100%;
    height: 100%;
  }
  .body {
    position: absolute;
    width: 90%;
    height: 90%;
    top: 46%;
    background: #151415;
    box-shadow: 0px 4px 4px #000000, inset 0px 4px 4px rgba(255, 255, 255, 0.06);
    border-radius: 10px;
  }
</style>
