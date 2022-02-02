import { writable } from "svelte/store";
export const Name = writable("")
export const OnDuty = writable(false) // On Duty true or false
export const Rank = writable("")
export const PolicesOnDuty = writable(0) // Amount of polices Online
export const PolicesOnCount = writable([]) // Polices Online on Duty
export const Vehicles_Report = writable([]) // VehiclesBolos
export const ImagesReport = writable([]) // Report Images
export const IS_VISIBLE = writable(false)
export const Reports = writable([])
export const Evidence = writable([])
export const isBoss = writable(false)