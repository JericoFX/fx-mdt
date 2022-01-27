<script lang="ts">
  import {fade, slide} from 'svelte/transition';
  import {fetchNui} from '../../utils/fetchNui';
  import {createEventDispatcher} from 'svelte';
  const dispatch = createEventDispatcher();
  export let open = false;
  export let evidencias = [];
  let Evidence = [];
  if (evidencias.length === 0) {
    fetchNui('getEvidence').then((cb) => {
      if (cb) {
        Evidence = cb;
        dispatch('sendEvidence', {Evidence});
      }
    });
  } else {
    Evidence = evidencias;
  }

  const closeModal = () => {
    open = false;
    dispatch('closeModal');
  };
</script>

{#if open}
  <div class="container absolute-center" style:width="991px" style:height="584px" style:background="#343441" style:box-shadow="0px 4px 4px #000000" style:border-radius="10px">
    <div
      class="centerContainer absolute-center"
      style="width: 85%;
    background: #151415;
    height: 85%;
    border-radius: 10px;
    box-shadow: 0px 4px 4px #000000;"
    >
      <div class="beforeTablet absolute-center" style="width:95%;height:90%;border-radius:10px;background:#191921 ;box-shadow:0px 4px 4px #000000">
        <div class="tableTemplate absolute-center" style="width:95%;height:90%;border-radius:10px;background:#343441 ;box-shadow:0px 4px 4px #000000">
          <div class="tabs fit">
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
                  {#each Evidence as env}
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
        </div>
      </div>
    </div>
    <div on:click={closeModal} class="buttonsito fixed-center" style:top="96.5%" style:width="228px" style:height="36px" style:border-radius="10px" style:background="#151415">
      <span class="text-center absolute-center">Close</span>
    </div>
  </div>
{/if}

<style>
  .buttonsito {
    box-shadow: 0px 0px 0px #000000;
  }
  .buttonsito:hover {
    transition: 0.1s;
    box-shadow: 0px 4px 4px #000000;
  }
  .buttonsito:active {
    transition: 0.1s;
    box-shadow: inset 0px 4px 4px #000000;
  }
</style>
