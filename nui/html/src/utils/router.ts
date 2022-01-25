import Members from "../Components/Members/Members_index.svelte"
import Warrants from "../Components/Report/Report_index.svelte"
import { wrap } from "svelte-spa-router/wrap"

export default{
  "/Members":wrap({
    component:Members
  }),
  "/Warrants":wrap({
    component:Warrants
  })
}