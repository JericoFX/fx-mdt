<script lang="ts">
  import {createEventDispatcher} from 'svelte';
import { push } from 'svelte-spa-router';
import { fetchNui } from '../../utils/fetchNui';
  const dispatch = createEventDispatcher();
	let Bolos = []
fetchNui("getVehicleBolos").then((cb) =>{
	if(cb){
		console.log(JSON.stringify(cb));
		
		Bolos = cb
	}
})

const veh = () =>{
	
}
</script>

<div class="container absolute-center">
  <div class="body absolute-center" >
		<div class="tabtarget">
			<div class="absolute-top" style="width:100%">
				<table class="table table-zebra q-mt-sm" style="width:100%" >
					<thead>
						<tr>
							<th></th> 
							<th>Plate</th> 
							<th>Vehicle</th> 
							<th>Model</th> 
							<th>Owner</th>
							<th>Color</th>
							<th>Report</th>
							<th></th> 
						</tr>
					</thead> 
					<tbody>
						{#each Bolos as veh }
						<tr>
							<td>-</td>
							<td>{veh.plate}</td>
							<td>{veh.vehicle}</td>
							<td>{veh.brand}</td>
							<td>{veh.citizenid}</td>
							<td><span class=" badge full-width" style={`background:${veh.color}`}></span>	</td>
							<!-- <td>></span></td> -->
							<th><button  on:click="{veh}" class="btn btn-sm text-center">Open Report</button></th>
						</tr>
						{/each}
					
					</tbody>
				</table>
			</div>
			

		</div>
	</div>
	<button  class="btn btn-wide btn-lg absolute-bottom" style="left:5%;bottom:0.5%;"> Add Report </button>
	<button on:click="{() => push("/")}" class="btn btn-wide btn-lg absolute-bottom" style="left:73%;bottom:0.5%;"> Close </button>
</div>

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
		top:46%;
    background: #151415;
    box-shadow: 0px 4px 4px #000000, inset 0px 4px 4px rgba(255, 255, 255, 0.06);
    border-radius: 10px;
  }
</style>
