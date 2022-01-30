<script lang="ts">
  import {createEventDispatcher} from 'svelte';
  const dispatch = createEventDispatcher();
  export let open = false;
  export let text = '';
  const closeModa = () => {
    open = false;
    dispatch('closedModal',{text});
  };
  $: console.log(open);
</script>

{#if open}
  <div class="modal-overlay">
    <div class="my-back fit" />
    <div class="container absolute-center" style:background="#151415">
      <div class="inputcontainer absolute-center" style:width="100%" style:height="100%">
        <textarea bind:value="{text}"
          class="absolute-center"
          name="jerico"
          id=""
          cols="2"
          rows="3"
          style="    width: 80%;
      height: 80%;
      top: 43%;
      border-radius: 5px;background:#343441;"
        />
      </div>
      <button on:click={closeModa} class="btn absolute-bottom" style:left="42%">CloseModal</button>
    </div>
  </div>
{/if}

<style>
  .container {
    width: 58%;
    height: 40%;
    max-width: 100%;
    max-height: 100%;
    background: #cccce4;
    border-radius: 10px;
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
