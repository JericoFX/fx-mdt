<script>
	// 	FIXME: cell not receive the data this probably bug on Grid.js
	export let cell;

 
  function printData(){
    console.log(cell);
  }
</script>

<button on:click={printData} >GrabData</button>
