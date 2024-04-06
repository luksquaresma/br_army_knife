def unpack_nested_lists(nlst, mode="comprehension"):
    # This takes in unordered and unstrucured nested lists and flattens
    # everything. Example: 
    #     Input:  [0, 1, [2, 3], [4, [5, [6, 7], 8], 9]]
    #     Output: [0 ,1, 2, 3, 4, 5, 6, 7, 8, 9]
    
    match mode:
        case "comprehension":
            return [
                item 
                for sublist in nlst 
                for item in (
                    unpack_nested_lists(sublist, mode="comprehension")
                    if isinstance(sublist, list)
                    else [sublist]
                    )
                ]
        case "loop":
            flist = []
            for item in nlst:
                if isinstance(item, list):
                    flist.extend(unpack_nested_lists(item, mode="loop"))
                else:
                    flist.append(item)
            return flist
        case _:
            raise ValueError("Invalid list unpacking method!")