<script lang="ts">
  import {createEventDispatcher, onMount} from 'svelte';
import { fetchNui } from '../../utils/fetchNui';
  const dispatch = createEventDispatcher();

  export let open = false;
  export let table = [];
  let Polices = table;
    let jerico = false
  const sendData = (e) => {
    Polices.push(e);
    Polices = Polices;
  };
  const closeModal = () => {
    open = false;
    dispatch('sendPolices', {Polices});
  };
  fetchNui("getPolices").then((cb) =>{
    if(cb){
      table = cb
    }
  })
</script>

{#if open}
  <div class="container absolute-center">
    <div class="body scroll">
      <div class="full-width ">
        <table id="Table1" class="table full-width table-zebra">
          <thead>
            <tr>
              <th>-</th>
              <th>Name</th>
              <th>Last Name</th>
              <th>CID</th>
              <th>Rank</th>
            </tr>
          </thead>
          <tbody>
            {#each table as fin}
              <tr class="hover">
                <th>
                  <input on:click={() => sendData(fin)}  type="checkbox" name="" id="" />
                </th>
                <th>{fin.Name.replaceAll('"', '')}</th>
                <td>{fin.LastName.replaceAll('"', '')}</td>
                <td>{fin.citizenid.replaceAll('"', '')}</td>
                <td>{fin.Rank.replaceAll('"', '')}</td>
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
