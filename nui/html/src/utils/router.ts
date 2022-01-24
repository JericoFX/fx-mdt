import Members from "../Components/Members/Members_index.svelte"
import { wrap } from "svelte-spa-router/wrap"

export default{
  "/Members":wrap({
    component:Members
  })
}