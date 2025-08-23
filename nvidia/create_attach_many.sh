/bin/bash -x

for i in $(seq 1 100); do
	nvmesh volume create --name "vol$i" --raid-level ec --data-blocks 1024 --capacity 2G --data-blocks 4 --parity-blocks 1 --protection-level ignore --stripe-width 1 --stripe-size 32
done



for i in $(seq 1 100); do
	nvmesh client attach --volume "vol$i" --id nvme31
done
for i in $(seq 1 100); do
	nvmesh client detach --volume "vol$i" --id nvme31
done


