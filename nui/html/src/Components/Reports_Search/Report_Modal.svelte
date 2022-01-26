<script lang="ts">
  import {createEventDispatcher} from 'svelte';
  const dispatch = createEventDispatcher();

  export let open = false;
  export let data = [];
  const closeModal = () => {
    open = false;
    dispatch('closeReport', {open});
  };
</script>
{#if open}

<div class="absolute-center">
  <div class="group_12_72_28 absolute-center">
    <div class="bodyapp_71_12 absolute-center" />
    <div class="body_71_13 fixed-center">
      <div class="name_73_36 absolute-center" style="    left: 21%;
      top: 18%;">
        <div class="rectangle_19_73_37" />
        <div class="rectangle_20_73_38" />
        <span class="name_73_39">Name</span><span class="texthere_73_40 text-center absolute-center" style="    top: 30%;
        left: 63%;">{data.name}</span>
      </div>
      <div class="lastname_73_41 absolute-center" style="    left: 20.5%;
      top: 29%;">
        <div class="rectangle_19_73_42" />
        <div class="rectangle_20_73_43 absolute-right" />
        <span class="last_name_73_44">Last Name</span><span class="texthere_73_45 absolute-right">{data.lastname}</span>
      </div>
      <div class="vehicle_73_46 absolute-center" style="    top: 40%;
      left: 20%;">
        <div class="rectangle_19_73_47" />
        <div class="rectangle_20_73_48" />
        <span class="vehicle_73_49">Vehicle</span><span class="texthere_73_50 absolute-right">{data.vehicleplate}</span>
      </div>
      <div class="info_73_51 absolute-right" style="    top: 14%;
      right: 1%;">
        <div class="rectangle_19_73_52" />
        <textarea disabled name="" id="" cols="30" rows="10" class="textplace_73_53 text-center" style="    width: 72%;
        max-width: 72%;
        margin-top: 0px;
        margin-bottom: 0px;
        height: 186px;
        max-height: 130px;
        min-height: 130px;">
          {data.information}
        </textarea>
        <span class="information_73_54" style="left: 0%;
        top: 38%;">Information</span>
      </div>
      <div class="id_73_29" style="    left: 15%;
      bottom: 2%;">
        <div class="image_73_33">
          <div class="rectangle_22_73_34" />
          <div class="imageshere_73_35 scroll hide-scrollbar absolute" style="    left: 1%;
          top: 4%;">
            <div class="fit">
              {#each data.imagenes as imgs}
                <img src={imgs} alt="" />
              {/each}
            </div>
          </div>
        </div>
      </div>
    </div>
    <div on:click={closeModal} class="atras_71_14 absolute-bottom" style="    top: 90%;
    left: 37%;" />
  </div>
</div>
  
{/if}
<style>
  .group_12_72_28 {
    width: 991px;
    height: 584px;
    position: absolute;
  }
  .bodyapp_71_12 {
    box-shadow: 0px 4px 4px rgba(0, 0, 0, 1);
    background-color: rgba(10.315104145556688, 10.315104145556688, 10.625000316649675, 1);
    width: 991px;
    height: 584px;
    position: absolute;

    border-top-left-radius: 50px;
    border-top-right-radius: 50px;
    border-bottom-left-radius: 50px;
    border-bottom-right-radius: 50px;
  }
  .body_71_13 {
    box-shadow: 0px 4px 4px rgba(0, 0, 0, 1);
    background-color: rgba(21.000000648200512, 20.000000707805157, 21.000000648200512, 1);
    width: 925px;
    height: 449.1381530761719px;
    position: absolute;

    border-top-left-radius: 50px;
    border-top-right-radius: 50px;
    border-bottom-left-radius: 50px;
    border-bottom-right-radius: 50px;
  }
  .atras_71_14 {
    box-shadow: 0px 4px 4px rgba(0, 0, 0, 1);
    background-color: rgba(52.390102967619896, 52.390102967619896, 64.81249898672104, 1);
    width: 228px;
    height: 44.55257797241211px;
    position: absolute;

    border-top-left-radius: 25px;
    border-top-right-radius: 25px;
    border-bottom-left-radius: 25px;
    border-bottom-right-radius: 25px;
  }
  .siguiente_71_20 {
    box-shadow: 0px 4px 4px rgba(0, 0, 0, 1);
    background-color: rgba(52.390102967619896, 52.390102967619896, 64.81249898672104, 1);
    width: 228px;
    height: 44.55257797241211px;
    position: absolute;

    border-top-left-radius: 25px;
    border-top-right-radius: 25px;
    border-bottom-left-radius: 25px;
    border-bottom-right-radius: 25px;
  }
  .name_73_36 {
    width: 363px;
    height: 33px;
    position: absolute;
  }
  .rectangle_19_73_37 {
    box-shadow: 0px 4px 4px rgba(0, 0, 0, 1);
    background-color: rgba(25.000000409781933, 25.000000409781933, 33.00000183284283, 1);
    width: 356.1001892089844px;
    height: 33px;
    position: absolute;
    border-top-left-radius: 25px;
    border-top-right-radius: 25px;
    border-bottom-left-radius: 25px;
    border-bottom-right-radius: 25px;
  }
  .rectangle_20_73_38 {
    background-color: rgba(52.390102967619896, 52.390102967619896, 64.81249898672104, 1);
    width: 257.86566162109375px;
    height: 33px;
    position: absolute;
    left: 105.13433837890625px;

    box-shadow: inset 0px 4px 4px #000000;
    border-top-left-radius: 25px;
    border-top-right-radius: 25px;
    border-bottom-left-radius: 25px;
    border-bottom-right-radius: 25px;
  }
  .name_73_39 {
    color: rgba(255, 255, 255, 1);
    width: 98.23453521728516px;
    height: 13.921875px;
    position: absolute;

    font-family: Poppins;
    text-align: center;
    font-size: 18px;
    letter-spacing: 0;
  }
  .texthere_73_40 {
    color: rgba(255, 255, 255, 1);
    width: 257.86566162109375px;
    height: 13.921875px;
    position: absolute;

    font-family: Poppins;
    text-align: center;
    font-size: 18px;
    letter-spacing: 0;
  }
  .lastname_73_41 {
    width: 356.2171325683594px;
    height: 33px;
    position: absolute;
  }
  .rectangle_19_73_42 {
    box-shadow: 0px 4px 4px rgba(0, 0, 0, 1);
    background-color: rgba(25.000000409781933, 25.000000409781933, 33.00000183284283, 1);
    width: 356.1001892089844px;
    height: 33px;
    position: absolute;

    border-top-left-radius: 25px;
    border-top-right-radius: 25px;
    border-bottom-left-radius: 25px;
    border-bottom-right-radius: 25px;
  }
  .rectangle_20_73_43 {
    background-color: rgba(52.390102967619896, 52.390102967619896, 64.81249898672104, 1);
    width: 257.86566162109375px;
    height: 33px;
    position: absolute;
    box-shadow: inset 0px 4px 4px #000000;

    border-top-left-radius: 25px;
    border-top-right-radius: 25px;
    border-bottom-left-radius: 25px;
    border-bottom-right-radius: 25px;
  }
  .last_name_73_44 {
    color: rgba(255, 255, 255, 1);
    width: 98.23453521728516px;
    height: 13.921875px;
    position: absolute;

    font-family: Poppins;
    text-align: center;
    font-size: 18px;
    letter-spacing: 0;
  }
  .texthere_73_45 {
    color: rgba(255, 255, 255, 1);
    width: 257.86566162109375px;
    height: 13.921875px;
    position: absolute;

    font-family: Poppins;
    text-align: center;
    font-size: 18px;
    letter-spacing: 0;
  }
  .vehicle_73_46 {
    width: 363px;
    height: 33px;
    position: absolute;
  }
  .rectangle_19_73_47 {
    box-shadow: 0px 4px 4px rgba(0, 0, 0, 1);
    background-color: rgba(25.000000409781933, 25.000000409781933, 33.00000183284283, 1);
    width: 356.1001892089844px;
    height: 33px;
    position: absolute;
    left: 6.78286075592041px;

    border-top-left-radius: 25px;
    border-top-right-radius: 25px;
    border-bottom-left-radius: 25px;
    border-bottom-right-radius: 25px;
  }
  .rectangle_20_73_48 {
    background-color: rgba(52.390102967619896, 52.390102967619896, 64.81249898672104, 1);
    width: 257.86566162109375px;
    height: 33px;
    position: absolute;
    left: 105.13433837890625px;

    box-shadow: inset 0px 4px 4px #000000;
    border-top-left-radius: 25px;
    border-top-right-radius: 25px;
    border-bottom-left-radius: 25px;
    border-bottom-right-radius: 25px;
  }
  .vehicle_73_49 {
    color: rgba(255, 255, 255, 1);
    width: 98.23453521728516px;
    height: 13.921875px;
    position: absolute;

    font-family: Poppins;
    text-align: center;
    font-size: 18px;
    letter-spacing: 0;
  }
  .texthere_73_50 {
    color: rgba(255, 255, 255, 1);
    width: 257.86566162109375px;
    height: 13.921875px;
    position: absolute;

    font-family: Poppins;
    text-align: center;
    font-size: 18px;
    letter-spacing: 0;
  }
  .info_73_51 {
    width: 483.7879943847656px;
    height: 133px;
    position: absolute;
  }
  .rectangle_19_73_52 {
    box-shadow: 0px 4px 4px rgba(0, 0, 0, 1);
    background-color: rgba(25.000000409781933, 25.000000409781933, 33.00000183284283, 1);
    width: 483.6291809082031px;
    height: 133px;
    position: absolute;
    left: 0px;

    border-top-left-radius: 25px;
    border-top-right-radius: 25px;
    border-bottom-left-radius: 25px;
    border-bottom-right-radius: 25px;
  }
  .textplace_73_53 {
    background-color: rgba(52.390102967619896, 52.390102967619896, 64.81249898672104, 1);
    width: 350.2142333984375px;
    height: 133px;
    position: absolute;
    left: 133.57376098632812px;

    box-shadow: inset 0px 4px 4px #000000;
    border-top-left-radius: 25px;
    border-top-right-radius: 25px;
    border-bottom-left-radius: 25px;
    border-bottom-right-radius: 25px;
  }
  .information_73_54 {
    color: rgba(255, 255, 255, 1);
    width: 133.41494750976562px;
    height: 56.109375px;
    position: absolute;

    font-family: Poppins;
    text-align: center;
    font-size: 18px;
    letter-spacing: 0;
  }
  .id_73_29 {
    width: 637px;
    height: 226.9942169189453px;
    position: absolute;
  }
  .image_73_33 {
    width: 637px;
    height: 226.9942169189453px;
    position: absolute;
    left: 0px;
  }
  .rectangle_22_73_34 {
    box-shadow: 0px 4px 4px rgba(0, 0, 0, 1);
    background-color: rgba(25.000000409781933, 25.000000409781933, 33.00000183284283, 1);
    width: 637px;
    height: 226.9942169189453px;
    position: absolute;
    left: 0px;

    border-top-left-radius: 25px;
    border-top-right-radius: 25px;
    border-bottom-left-radius: 25px;
    border-bottom-right-radius: 25px;
  }
  .imageshere_73_35 {
    background-color: rgba(52.390102967619896, 52.390102967619896, 64.81249898672104, 1);
    width: 626px;
    height: 209px;
    position: absolute;

    border-top-left-radius: 25px;
    border-top-right-radius: 25px;
    border-bottom-left-radius: 25px;
    border-bottom-right-radius: 25px;
  }
</style>
