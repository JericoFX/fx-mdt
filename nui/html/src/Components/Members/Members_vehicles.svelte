<script lang="ts">
  import {createEventDispatcher} from 'svelte';
  import {fade, fly} from 'svelte/transition';
  const dispatch = createEventDispatcher();
  export let open = false;
  export let vehicles = [];
  const sendData = () => {
    open = false;
    dispatch('playerSelected', {open});
  };
</script>

{#if open}
  <div class="modal-overlay" transition:fade={{duration: 100}}>
    <div class="my-back fit" />
    <div class="modals absolute-center">
      <div class="fixed-center colorsito">
        <div class="modelsName absolute-center" style="left:25%;top:15%;">
          <p class="absolute-center text-h6 text-white" style="left:16%">Vehicle</p>
          <div class="modelsData absolute-right ">
            <p class="absolute-center text-capitalize" style="color:white">{vehicles.vehicle}</p>
          </div>
        </div>

        <div class="modelsName absolute-center" style="left:25%;top:35%;">
          <p class="absolute-center text-h6 text-white" style="left:16%">Brand</p>
          <div class="modelsData absolute-right">
            <p class="absolute-center text-capitalize" style="color:white">something</p>
          </div>
        </div>

        <div class="modelsName absolute-center" style="left:25%;top:55%;">
          <p class="absolute-center text-h6 text-white" style="left:16%">Plate</p>
          <div class="modelsData absolute-right">
            <p class="absolute-center text-uppercase" style="color:white">{vehicles.plate}</p>
          </div>
        </div>
        <!-- 	FUEL -->
        <div class="modelsName absolute-center" style="left:75%;top:55%;">
          <p class="absolute-center text-h6 text-white" style="left:16%">Body</p>
          <div class="modelsData absolute-right">
            <div
              class="modelsData"
              style={"background: #2901CB;      box-shadow: inset 0px 4px 4px #000000; width:"+vehicles.bodyHealth / 10+"%"}            />
          </div>
        </div>
        <!-- 	Engine -->
        <div class="modelsName absolute-center" style="left:75%;top:35%;">
          <p class="absolute-center text-h6 text-white" style="left:16%">Engine</p>
          <div class="modelsData absolute-right">
            <div
              class="modelsData"
              style={"background: #CB6201; box-shadow: inset 0px 4px 4px #000000; width:"+vehicles.engineHealth / 10+"%"} />
          </div>
        </div>
        <!-- 	Body -->
        <div class="modelsName absolute-center" style="left:75%;top:15%;">
          <p class="absolute-center text-h6 text-white" style="left:16%">Fuel</p>
          <div class="modelsData absolute-right">
            <div
              class="modelsData"
              style={"background: #CB7A01; box-shadow: inset 0px 4px 4px #000000; width:"+vehicles.fuelLevel +"%"}
            />
          </div>
        </div>
        <div on:click="{sendData}" class="absolute-center" style="top:90%;">
          <div class="button absolute-center">
            <p class="absolute-center text-uppercase" style="color:white">Close</p>
          </div>
        </div>
      </div>
    </div>
  </div>
{/if}

<style>
  .modals {
    position: absolute;
    width: 537px;
    height: 100%;
    border-radius: 5px;
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
  .colorsito {
    width: 90.4vh;
    height: 59%;
    background: #0a0a0b;
    box-shadow: 0px 4px 4px #000000, inset 0px 4px 4px rgba(255, 255, 255, 0.06);
    border-radius: 5px;
  }

  :root {
    background-color: transparent;
  }
  .modelsName {
    position: absolute;
    width: 315px;
    height: 64px;
    max-width: 100%;
    max-height: 100%;
    background: #191921;
    box-shadow: 0px 4px 4px #000000;
    border-radius: 5px;
  }

  .modelsData {
    width: 228.1px;
    height: 64px;
    max-width: 100%;
    max-height: 100%;
    background: #343441;
    box-shadow: inset 0px 4px 4px #000000;
    border-radius: 5px;
  }
  .button {
    position: absolute;
    width: 228.1px;
    height: 64px;

    background: #343441;
    box-shadow: 0px 4px 4px #000000;
    border-radius: 5px;
  }
</style>
