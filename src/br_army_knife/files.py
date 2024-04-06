import shutil, os


def clear_contents(saving_dir, log=None):
    if os.path.exists(saving_dir):
        if log: log.log(f'CLEARING RESULT DATA ON {saving_dir}.')
        shutil.rmtree(saving_dir)
    os.mkdir(f'{saving_dir}/')


def create_complete_path(path):
    # recieves paths as "/d1/d2/d3" and "./d1/d2/d3/xyz.wkl"
    def create_path(p):
        if not os.path.exists(p):
            os.makedirs(p)

    if len(path) == 0:
        raise ValueError("Invalid path")
    
    prefix, sulfix = "", ""
    sl = path.split("/")

    if sl[0][0] == ".":
        prefix, sl = sl[0], sl[1:]
    if "." in sl[-1]:
        sulfix, sl = sl[-1], sl[:-1]
        
    for ps in [sl[:i+1] for i in range(len(sl))]:
        create_path("/".join(map(str,[prefix, *ps])))


