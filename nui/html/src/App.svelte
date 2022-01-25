<script lang="ts">
  import Router, {push} from 'svelte-spa-router';
  import routes from './utils/router';
  import {fetchNui} from "./utils/fetchNui"
  import {Name,OnDuty,PolicesOnDuty,Rank,PolicesOnCount,IS_VISIBLE} from './store/store';
  import { useNuiEvent } from './utils/useNuiEvent';
  $: isVisible = true

  const APP = [
    {name: 'Members', icon: 'iconos/people.png'},
    {name: 'Vehicles', icon: 'iconos/sedan.png'},
    {name: 'Warrants', icon: 'iconos/browse_page.png'},
  ];
  const handleClick = (name: string) => {

    push(`/${name}`);
  };
  useNuiEvent("openMDT",({visible,name,onDuty,rank})=>{
    $IS_VISIBLE = visible
    $Name = name
    $OnDuty = onDuty
    $Rank = rank
  })
  useNuiEvent("onDutyPolices",({policesOnDuty,policesData})=>{
      $PolicesOnDuty = policesOnDuty
      $PolicesOnCount = policesData
  })
  function handleKeydown(event) {
    if (event.keyCode === 27) {
      $IS_VISIBLE = false
      fetchNui('exitMDT');
    }
  }
  const changeDuty = () =>{
    $OnDuty =! $OnDuty
  fetchNui("changeDuty",({ Duty: $OnDuty}))
}
</script>
<svelte:window on:keydown={handleKeydown} />
{#if $IS_VISIBLE}

  <div class="container fixed-center2 non-selectable">
    <div class="bodyApp fixed-center">
      <img src="iconos/back.jpg" style:border-radius="25px" class="fit" alt="" />
      <div class="fixed-center q-mb-lg" style="display: flex;
      flex-direction: row;
      flex-wrap: nowrap;
      align-content: space-between;
       justify-content: center;
      align-items: stretch;">
        {#each APP as ap}
          <p on:click={() => handleClick(ap.name)} class="text-center shadow mx-8  rounded-box shadow-lg bg-neutral ">
            <img src={ap.icon} class="bg-sky-600 hover:bg-sky-700" alt="altv" style:width="256px" />
            <span class="text-h6 ">{ap.name}</span>
          </p>
        {/each}
       
      </div>
      <Router {routes} />
    </div>

    <!-- INFORMATION PANEL -->

    <div class="information ">
      <div class="policesOnline policesInfo shadow absolute-top q-mt-sm" style="left: 8%;">
        <p class="fit text-center">Polices Online</p>
        <p class="absolute-center text-center q-mt-sm polices-text">{$PolicesOnCount.length}</p>
      </div>
      <div class="policesOnline policesInfo shadow absolute-center">
        <p class="fit text-center">Polices On Duty</p>
        <p class="absolute-center text-center q-mt-sm polices-text" style="color:#95f279 ">{$PolicesOnDuty}</p>
      </div>
      <div class="policesOnline policesInfo  shadow absolute-bottom q-mb-sm" style="left: 8%;">
        <p class="fit text-center ">Ordenes</p>
        <p class="absolute-center text-center q-mt-sm polices-text">10</p>
      </div>
    </div>

    <div class="logo">
      <img class="image shadow" src="iconos/LSPD.png" alt="" />
    </div>
    <div
      class="myinfo-container absolute-right"
      style="top:31px;right:12px;background: #101014;
    box-shadow: 0px 4px 4px rgba(0, 0, 0, 0.25);
    border-radius: 10px;width: 191px;
    height: 255px; "
    >
      <div class="onDutyInfo  absolute-bottom buttonRanks shadow" style="position:absolute;        left:5%;        bottom:6%;      ">
        <div class="colorbar absolute-center" style={!$OnDuty ? 'background:#FF0000;  width: 85px;height: 3px;top:86%; ;box-shadow: 0px 4px 4px rgba(0, 0, 0, 0.25);filter: blur(2px);border-radius: 3px; ' : 'background:#00FF19; width: 85px;height: 3px;top:86%; ;box-shadow: 0px 4px 4px rgba(0, 0, 0, 0.25);filter: blur(2px);border-radius: 3px; '} />
        <p class=" absolute-center text-center">{!$OnDuty ? 'OFF Duty' : 'ON Duty'}</p>
      </div>
      <div class="isBoss absolute-center buttonRanks shadow">
        <p class=" absolute-center text-center">{$Rank}</p>
      </div>
      <div class="name  buttonRanks shadow" style="left:5%; top:6%;position:absolute;">
        <p class=" absolute-center text-center">{$Name}</p>
      </div>
    </div>
    <div class="helppanel">
      <div class="helpbutton1 absolute-bottom buttonRanks shadow" style="bottom:15%;left:5%;">
        <p class=" absolute-center text-center">Send Mail</p>
      </div>
      <div class="callhelp absolute-center buttonRanks shadow">
        <p class=" absolute-center text-center">Call Help</p>
      </div>
      <div on:click={changeDuty} class="onDuttyButton absolute-top buttonRanks shadow" style=" top:16%;left:5%;">
        <p class=" absolute-center text-center">{$OnDuty ? 'OUT Duty' : 'In Duty'}</p>
      </div>
    </div>
  </div>

{/if}

<style global>
  :root{
    background-color: transparent;
  }
  :global(*) {
    font-family: 'Poppins', sans-serif;
    font-style: normal;
    font-weight: normal;
    font-size: 14px;
    line-height: 27px;
  }
  :global(.fixed-center2) {
    position: fixed;
    left: 50%;
    top: 50%;
    transform: translate(-50%, -50%);
    width: 1536px;
    height: 768px;
    max-width: 100%;
    max-height: 100%;
    background: #0c0c0f;
    border-radius: 10px;
  }
  .bodyApp {
    position: absolute;
    width: 67%;
    height: 92%;
    max-width: 100%;
    max-height: 100%;
    background: #0a0a0b;
    border-radius: 10px;
  }
  .information {
    position: absolute;
    width: 21.8vh;
    height: 38.5vh;
    left: 12px;
    top: 44%;
    max-width: 100%;
    max-height: 100%;
    background: #101014;

    border-radius: 10px;
  }
  .logo {
    position: absolute;
    width: 22.3vh;
    height: 26.3vh;
    left: 12px;
    top: 31px;
    max-width: 100%;
    max-height: 100%;
    background: #101014;

    border-radius: 10px;
  }
  .image {
    position: absolute;
    width: 21.3vh;
    height: 25.4vh;
    left: 6px;
    top: 6px;
    max-width: 100%;
    max-height: 100%;
    filter: drop-shadow(0px 4px 4px #000000);
    border-radius: 10px;
  }

  .helppanel {
    position: absolute;
    width: 191px;
    height: 255px;
    right: 12px;
    top: 430px;
    background: #101014;

    border-radius: 10px;
    max-width: 100%;
    max-height: 100%;
  }


  .buttonRanks {
    width: 17.3vh;
    height: 3.7vh;
    max-width: 100%;
    max-height: 100%;
    background: rgb(16, 16, 20);
    border-radius: 10px;
  }
  :global(.shadow){
    box-shadow: 0px 4px 4px rgba(0, 0, 0, 0);
    transition: 0.5s;
  }

  :global(.shadow:hover){
    box-shadow: 0px 4px 4px #00d9ff;
  }
  .policesInfo {
    position: absolute;
    width: 191px;
    height: 94px;
    background: rgba(25, 25, 33, 0.96);
    border-radius: 10px;
  }
  .polices-text {
    font-style: normal;
    font-weight: normal;
    font-size: 48px;
    line-height: 56px;
    display: flex;
    align-items: center;
    text-align: center;

    color: #79b1f2;

    text-shadow: 0px 4px 4px #101014;
  }
</style>
