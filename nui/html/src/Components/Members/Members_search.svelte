<script lang="ts">
  import {createEventDispatcher} from 'svelte';
  import {fade, fly} from 'svelte/transition';
  const dispatch = createEventDispatcher();
  export let open = false;
  export let players = [];
  const sendData = (data: []) => {
    open = false;
    dispatch('playerSelected', {data});
  };
  const closeModal = () =>{
    open = false;
    players.length = 0
    dispatch('playerClosed', {open});
  }
</script>

{#if open}
  <div class="modal-overlay" transition:fade={{duration: 100}}>
    <div class="my-back fit" />
    <div class="modals absolute-center">
      <table class="table w-full table-zebra">
        <thead>
          <tr>
            <th />
            <th>Name</th>
            <th>Last Name</th>
          </tr>
        </thead>
        <tbody>
          {#each players as pla}
            <tr on:click={() => sendData(pla)}>
              <th>-</th>
              <th>{pla.Name}</th>
              <th>{pla.LastName}</th>
            </tr>
          {/each}
        </tbody>
      </table>
     <button on:click="{closeModal}" class="btn fixed-bottom" style="left:43%">Close</button>
    </div>
  </div>
{/if}

<style>
  .modals {
    position: absolute;
    width: 537px;
    height: 245px;
    background: rgba(25, 25, 33, 0.96);
    box-shadow: 0px 4px 4px rgba(0, 0, 0, 0.59);
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
</style>
