<script lang="ts">
  import {createEventDispatcher} from 'svelte';
  const dispatch = createEventDispatcher();
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
						<tr>
							<th>-</th> 
							<td>25HMB316</td> 
							<td>Manana</td> 
							<td>Karin</td>
							<td>FQI55932</td>
							<td><span class=" badge full-width" style="background:red;"></span></td>
							<th><button class="btn btn-sm text-center">Open Report</button></th>
							<th>-</th>
						</tr>
					</tbody>
				</table>
			</div>
			

		</div>
	</div>
	<button class="btn btn-wide btn-lg absolute-bottom" style="left:5%;bottom:0.5%;"> Add Report </button>
	<button class="btn btn-wide btn-lg absolute-bottom" style="left:88.5%;bottom:0.5%;"> Close </button>
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
		top:48%;
    background: #151415;
    box-shadow: 0px 4px 4px #000000, inset 0px 4px 4px rgba(255, 255, 255, 0.06);
    border-radius: 10px;
  }
</style>
