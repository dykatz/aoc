#!/usr/bin/env sh

janet 01/src.janet <01/input.txt

cd 02
janet src.janet
janet src-p2.janet
cd ..

janet 03/src.janet <03/input.txt

cd 04
janet src.janet
cd ..

janet 05/src.janet <05/input.txt
janet 05/src-p2.janet <05/input.txt

janet 06/src.janet <06/input.txt
janet 06/src-p2.janet <06/input.txt

janet 07/src.janet <07/input.txt
janet 07/src-p2.janet <07/input.txt

janet 08/src.janet <08/input.txt
janet 08/src-p2.janet <08/input.txt

janet 09/src.janet <09/input.txt
janet 09/src-p2.janet <09/input.txt

janet 10/src.janet <10/input.txt
janet 10/src-p2.janet <10/input.txt | python3 10/src-p2.py

janet 11/src.janet <11/input.txt
janet 11/src-p2.janet <11/input.txt

cd 12
janet src.janet
cd ..
