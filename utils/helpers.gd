## Library of helper functions
extends RefCounted
class_name Helper

## Checks if [param arr1] and [param arr2] intersect
static func arrays_intersect(arr1: Array, arr2: Array) -> bool:
	var intersect = false
	for element: Variant in arr1:
		if arr2.has(element):
			intersect = true
			break
	return intersect
