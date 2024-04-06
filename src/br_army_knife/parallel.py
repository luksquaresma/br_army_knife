import multiprocessing, threading

class MultiLock():
    def __init__(self, lock=False, lock_type="multiprocessing"):
        self.ml_handle = "ml_handle"
        
        if not lock:
            match lock_type:
                case "multiprocessing":
                    self.lock = multiprocessing.Lock()
                case "threading":
                    self.lock = threading.Lock()
                case _:
                    raise ValueError("Invalid lock_type!")
            globals()[self.ml_handle] = self
        else:
            self = globals()[self.ml_handle]

    def aquire(self):
        self.lock.acquire()

    def release(self):
        self.lock.release()

    def __enter__(self):
        self.aquire()
        return self 

    def __exit__(self, exc_type, exc_value, traceback):
        self.release()        
    

            
