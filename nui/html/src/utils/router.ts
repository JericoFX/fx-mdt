import Members from "../Components/Members/Members_index.svelte"
import Warrants from "../Components/Report/Report_index.svelte"
import Report from "../Components/Reports_Search/Report_search_index.svelte"
import { wrap } from "svelte-spa-router/wrap"

export default{
  "/Members":wrap({
    component:Members
  }),
  "/Reports/:Name?/:last?/:CitizenID?":wrap({
    component:Warrants,

  }),
  "/Search":wrap({
    component:Report
  })
}