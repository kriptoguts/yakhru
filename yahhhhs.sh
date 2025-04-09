#!/bin/bash

rm -f G.O.D2/core/config/base.yml

cat > G.O.D2/core/config/base.yml <<EOL
base_model: NousResearch/Meta-Llama-3-8B-Instruct
model_type: AutoModelForCausalLM
tokenizer_type: AutoTokenizer

load_in_8bit: false
load_in_4bit: false
strict: false

chat_template: llama3
datasets:
dataset_prepared_path:
val_set_size: 0.05
output_dir: miner_id_24

sequence_len: 512
sample_packing: false
pad_to_sequence_len: true
trust_remote_code: true

adapter: lora
lora_model_dir:
lora_r: 128
lora_alpha: 64
lora_dropout: 0.05
lora_bias: "none"
lora_target_linear: true
lora_fan_in_fan_out: null
lora_target_modules:
  - q_proj
  - k_proj
  - v_proj
  - o_proj
  - gate_proj
  - up_proj
  - down_proj

gradient_accumulation_steps: 8
micro_batch_size: 2
num_epochs: 3
optimizer: adamw_bnb_8bit
lr_scheduler: cosine
learning_rate: 0.0001

train_on_inputs: false
group_by_length: true
bf16: auto
fp16: false
tf32: false

gradient_checkpointing: true
early_stopping_patience:
resume_from_checkpoint:
local_rank:
logging_steps: 10
xformers_attention: false
flash_attention: true
s2_attention: false

wandb_project: Gradients-On-Demand
wandb_entity:
wandb_mode: online
wandb_run: your_name
wandb_runid: default

hub_model_id:
hub_repo:
hub_strategy: checkpoint
hub_token:

saves_per_epoch: 2
warmup_steps: 50
evals_per_epoch: 2
eval_table_size:
eval_max_new_tokens: 128
max_steps: 100
debug:
deepspeed:
weight_decay: 0.01
fsdp:
fsdp_config:

EOL
