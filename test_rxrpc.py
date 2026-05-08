#!/usr/bin/python3

import socket
import ctypes
import ctypes.util
import os

AF_RXRPC_FALLBACK = 33
SOCK_DGRAM = socket.SOCK_DGRAM
PF_INET = socket.AF_INET
EAFNOSUPPORT = 97

def create_socket_via_python():
    soc = socket.socket(socket.AF_RXRPC, SOCK_DGRAM, PF_INET)
    return soc

def create_socket_via_ctypes():
    libc_path = ctypes.util.find_library("c")
    if not libc_path:
        raise RuntimeError("Could not find libc")

    libc = ctypes.CDLL(libc_path, use_errno=True)
    c_socket = libc.socket
    c_socket.argtypes = [ctypes.c_int, ctypes.c_int, ctypes.c_int]
    c_socket.restype = ctypes.c_int

    soc = c_socket(AF_RXRPC_FALLBACK, SOCK_DGRAM, PF_INET)
    if soc < 0:
        err = ctypes.get_errno()
        raise OSError(err, os.strerror(err))
    return soc
def main():
    try:
        if hasattr(socket, "AF_RXRPC"):
            print(f"Python has AF_RXRPC: {socket.AF_RXRPC}")
            soc = create_socket_via_python()
            print(f"RXRPC exists, system may be vulnerable: soc={soc.fileno()}")
            soc.close()
        else:
            print("Python does not expose AF_RXRPC, using ctypes")
            soc = create_socket_via_ctypes()
            print(f"RXRPC exists, system may be vulnerable: soc={soc}")
            os.close(soc)

    except OSError as e:
        print(f"socket call failed with errno={e.errno}: {e.strerror}")

        if e.errno == EAFNOSUPPORT:
            print("This explicitly shows the running kernel does not support AF_RXRPC.")
        else:
            print("AF_RXRPC was not usable, the kernel may support it.")

if __name__ == "__main__":
    main()
