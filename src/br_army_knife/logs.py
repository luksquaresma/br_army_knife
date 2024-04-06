import datetime
from . import files
from . import parallel

class Log():
    # Simple log implementation
    def __init__(self, log_path:str, log_file:bool=True, log_terminal:bool=False, parallel_lock=False):
        self.log_terminal = log_terminal    # log in the terminal?
        self.log_file = log_file            # log in a file?
        self.log_path = log_path            # path for the log file
        self.parallel_lock = parallel_lock  # log in paralel? if so, with wich lock?
        if log_file:
            files.create_complete_path(log_path)

        if parallel_lock:
            self.lock_handle = parallel.MultiLock().ml_handle


    def log(self, msg:str):
        if self.parallel_lock: globals()[self.lock_handle].aquire()
        if self.log_terminal: print(msg, flush=True)
        if self.log_file:
            with open(self.log_path, 'a') as file:
                file.write(f'{datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")}    {msg}\n')
        if self.parallel_lock: globals()[self.lock_handle].release()
