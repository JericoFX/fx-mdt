<script lang="ts">
  import {createEventDispatcher, onMount} from 'svelte';
  import Fines from '../../utils/fines';
  const dispatch = createEventDispatcher();
  export let open = false;
  export let table = [];
  let FinesAdded = table;
  const sendData = (e) => {
    FinesAdded.push(e);
    FinesAdded = FinesAdded;
  };
  const closeModal = () => {
    open = false;
    dispatch('sendFines', {FinesAdded});
  };
</script>

{#if open}
  <div class="container absolute-center">
    <div class="body scroll">
      <div class="full-width ">
        <table id="Table1" class="table full-width table-zebra">
          <thead>
            <tr>
              <th>-</th>
              <th>ID</th>
              <th>label</th>
              <th>Jail Time</th>
              <th>Amount</th>
            </tr>
          </thead>
          <tbody>
            {#each Fines as fin}
              <tr class="hover">
                <th>
                  <input on:click={() => sendData(fin)} type="checkbox" name="" id="" />
                </th>
                <th>{fin.id}</th>
                <td>{fin.label}</td>
                <td>{fin.jailtime}</td>
                <td>{fin.amount}</td>
              </tr>
            {/each}
          </tbody>
        </table>
      </div>
    </div>
    <button on:click={closeModal} class="btn absolute-bottom">Close Modal</button>
  </div>
{/if}

<style>
  .container {
    width: 80%;
    height: 80%;
    position: absolute;
    background: #0a0a0b;
    box-shadow: 0px 4px 4px #000000, inset 0px 4px 4px rgba(255, 255, 255, 0.06);
    border-radius: 10px;
  }
  .body {
    width: 95%;
    height: 90%;
    background: #343441;
    box-shadow: 0px 4px 4px #000000, inset 0px 4px 4px rgba(255, 255, 255, 0.06);
    border-radius: 10px;
  }
</style>
