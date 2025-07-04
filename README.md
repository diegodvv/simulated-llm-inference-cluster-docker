# Como usar

Primeiro, faça um build da imagem no `docker build -t distributed_llama:latest .`

Depois, suba 2 instâncias usando o `docker compose up -d --force-recreate`

Entre em uma delas e execute `python launch.py llama3_2_1b_instruct_q40` para baixar um modelo na pasta `models/`

Depois, nos containers filhos `distributed_llama_node_2` rode `./dllama worker --nthreads 4`

Entre no container raiz `distributed_llama_node_1` com `docker exec -it distributed_llama_node_1 bash` rode 
`ping distributed_llama_node_2` e anote o IP de cada filho
E então rode
 `./dllama inference --model models/llama3_2_1b_instruct_q40/dllama_model_llama3_2_1b_instruct_q40.m --tokenizer models/llama3_2_1b_instruct_q40/dllama_tokenizer_llama3_2_1b_instruct_q40.t --buffer-float-type q80 --prompt "Generate a docker compose file for nginx with postgres database" --steps 256 --nthreads 4 --workers 172.21.0.3:9990 172.21.0.3:9990`

`./dllama chat --model models/llama3_2_1b_instruct_q40/dllama_model_llama3_2_1b_instruct_q40.m --tokenizer models/llama3_2_1b_instruct_q40/dllama_tokenizer_llama3_2_1b_instruct_q40.t --buffer-float-type q80 --nthreads 16 --max-seq-len 4096`

Os nós workers devem ser listados em `--workers` com os seus IPs e a porta 9990

## Como usar para configurar um cluster real

Em cada computador que será um worker instale o Docker e rode `docker compose -f docker-compose-1n-worker.yml up -d --force-recreate`.

Isso fará com que ele rode o distributed llama e o disponibilize na porta 9990 (cuidado ao utilizar isso em redes públicas, é possível 
que existam vulnerabilidades no distributed llama e se os computadores estiverem accesíveis a terceiros você pode acabar expondo eles a
hackers).

No computador raiz, onde o resultado da inferência será exibido, rode `docker compose -f docker-compose-1n.yml up -d --force-recreate`.
Então rode `docker exec -ti distributed_llama_node_1 bash` e por fim rode o comando dllama inference exibido acima. Os IPs devem ser
os IPs locais das máquinas workers.
