<script lang="ts">
  import {push} from 'svelte-spa-router';
  import {fetchNui} from '../../utils/fetchNui';
  import Report_Modal from './Report_Modal.svelte';
  import Report_Evidence from '../Report/Report_Evidence.svelte';
  let Data = [];
  let OpenModal = false;
  fetchNui('getReports', {}).then((cb) => {
    if (cb) {
      Data = cb;
    }
  });
  let puto = [
    {type: 'casing', street: 'Sinner Street | Atlee Street', ammotype: 453432689, ammolabel: '9x19mm parabellum bullet'},
    {type: 'casing', street: 'San Andreas Avenue | ', ammotype: 453432689, ammolabel: '9x19mm parabellum bullet'},
    {type: 'blood', street: 'Atlee Street | ', dnalabel: '4c54583635303934', bloodtype: 'B-'},
  ];

  const openReportModal = (data) => {
    OpenModal = true;
    const Div = document.getElementById('id');
    let m = new Report_Modal({
      target: Div,
      props: {
        open: OpenModal,
        data: data,
      },
    });
    m.$on('closeReport', () => {
      OpenModal = false;
    });
    return m;
  };

  const getCurrentEvidence = (env) => {
    const Div = document.getElementById('id');
    OpenModal = true;
    let m = new Report_Evidence({
      target: Div,
      props: {open: OpenModal, evidencias: env},
    });
    m.$on('closeModal', () => (OpenModal = false));
  };
</script>

<div class="group_12_72_28 absolute-center">
  <div class="bodyapp_71_12" />
  <div class="body_71_13">
    <div class="fit">
      <table class="table table-zebra " style="width:100%">
        <thead>
          <tr>
            <th>Name</th>
            <th>last Name</th>
            <th>Vehicle</th>
            <th>Information</th>
            <th>Imagenes</th>
            <th>Evidencias</th>
          </tr>
        </thead>
        <tbody>
          {#each Data as players}
            <tr>
              <th>{players.name}</th>
              <td>{players.lastname}</td>
              <td>{players.vehicleplate || 'No Vehicle'}</td>
              <td>{players.information}</td>
              <td on:click={() => openReportModal(players)} class="text-center"><button class="btn btn-sm"> Open Data</button></td>
              <td on:click={() => getCurrentEvidence(players.evidencias)} class="text-center"><button class="btn btn-sm"> Open Evidences</button></td>
            </tr>
          {/each}
        </tbody>
      </table>
    </div>
  </div>
  <div on:click={() => push('/')} class="atras_71_14" />

  <div class="siguiente_71_20" />
</div>
<div id="id" />

<style>
  .group_12_72_28 {
    width: 991px;
    height: 485px;
    position: absolute;
  }
  .bodyapp_71_12 {
    box-shadow: 0px 4px 4px rgba(0, 0, 0, 1);
    background-color: rgba(10.315104145556688, 10.315104145556688, 10.625000316649675, 1);
    width: 991px;
    height: 485px;
    position: absolute;
    left: 0px;
    top: 0px;
    border-top-left-radius: 50px;
    border-top-right-radius: 50px;
    border-bottom-left-radius: 50px;
    border-bottom-right-radius: 50px;
  }
  .body_71_13 {
    box-shadow: 0px 4px 4px rgba(0, 0, 0, 1);
    background-color: rgba(21.000000648200512, 20.000000707805157, 21.000000648200512, 1);
    width: 925px;
    height: 373px;
    position: absolute;
    left: 40px;
    top: 17px;
    border-top-left-radius: 50px;
    border-top-right-radius: 50px;
    border-bottom-left-radius: 50px;
    border-bottom-right-radius: 50px;
  }
  .atras_71_14 {
    box-shadow: 0px 4px 4px rgba(0, 0, 0, 1);
    background-color: rgba(52.390102967619896, 52.390102967619896, 64.81249898672104, 1);
    width: 228px;
    height: 37px;
    position: absolute;
    left: 24px;
    top: 427px;
    border-top-left-radius: 25px;
    border-top-right-radius: 25px;
    border-bottom-left-radius: 25px;
    border-bottom-right-radius: 25px;
  }
  .siguiente_71_20 {
    box-shadow: 0px 4px 4px rgba(0, 0, 0, 1);
    background-color: rgba(52.390102967619896, 52.390102967619896, 64.81249898672104, 1);
    width: 228px;
    height: 37px;
    position: absolute;
    left: 720px;
    top: 427px;
    border-top-left-radius: 25px;
    border-top-right-radius: 25px;
    border-bottom-left-radius: 25px;
    border-bottom-right-radius: 25px;
  }
</style>
