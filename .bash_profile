eval "$(starship init bash)"
# Colors
black="\[$(tput setaf 0)\]"
red="\[$(tput setaf 1)\]"
green="\[$(tput setaf 2)\]"
yellow="\[$(tput setaf 3)\]"
blue="\[$(tput setaf 4)\]"
magenta="\[$(tput setaf 5)\]"
cyan="\[$(tput setaf 6)\]"
white="\[$(tput setaf 7)\]"
# Title bar - "user@host: ~"
title="\u@\h: \w"
titlebar="\[\033]0;""\007\]"
# Git branch
git_branch() {   git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)\ /'; }
# Clear attributes
clear_attributes="\[$(tput sgr0)\]"

export PS1="${cyan}(admin${green}@${cyan}localhost) ${magenta}\W ${green}#${clear_attributes} "
source /etc/profile.d/bash_completion.sh
source <(kubectl completion bash)
alias k=kubectl
complete -F __start_kubectl k
termwidth="$(tput cols)"

# Adjust the spacing for the "Welcome to ..." and "All rights ..." lines.

left_align() {
  local padding="$(printf '%0.1s' \ {1..500})"
  local padding_percentage="$1"
  local padding_width=$((termwidth*padding_percentage/100))
  printf '%*.*s %s %*.*s\n' "$padding_width" "$padding_width" "$padding" "$2" 0 "$((termwidth-1-${#2}-padding_width))" "$padding"
}

left_align 6 "Welcome to the KodeKloud Hands-On lab"
figlet -w ${termwidth} -f slant KODEKLOUD | lolcat
left_align 10 "All rights reserved"
source /root/.bashrc 2>/dev/null
export CLAUDE_API_KEY=Sk-kkAI-d992386444e314dc9156dfce8f082706ec124573ad36a0b103515cf8615d3799kk_hakhevsvzhsbqpfx-kkb552a465
export GROQ_API_KEY=Sk-kkAI-d992386444e314dc9156dfce8f082706ec124573ad36a0b103515cf8615d3799kk_hakhevsvzhsbqpfx-kkb552a465
export ALLOWED_MODELS=x-ai/grok-code-fast-1,x-ai/grok-3-beta,openai/gpt-4.1,qwen/qwen3-32b:free,deepseek/deepseek-chat-v3-0324:free,deepseek/deepseek-reasoner,google/gemini-2.0-flash-exp:free,google/gemini-2.5-flash-image-preview,meta-llama/llama-4-maverick:free,anthropic/claude-sonnet-4,google/gemini-2.5-flash,google/gemini-2.5-pro,openai/gpt-5,moonshot/kimi-k2-0711-preview,deepseek/deepseek-r1-0528:free,openai/gpt-4o-2024-11-20,openai/gpt-4.1-nano,openai/gpt-4.1-mini,moonshotai/kimi-k2-0905,deepseek/deepseek-chat,openai/gpt-5-nano,alibaba/qwen3-coder-plus,openai/gpt-5-mini,openai/o3,openai/o4-mini,moonshotai/kimi-k2:free,moonshotai/kimi-k2,x-ai/grok-3
export OPENAI_API_BASE=https://kodekey.ai.kodekloud.com/v1
export AZURE_OPENAI_ENDPOINT=https://kodekey.ai.kodekloud.com/openai
export OPENAI_API_KEY=Sk-kkAI-d992386444e314dc9156dfce8f082706ec124573ad36a0b103515cf8615d3799kk_hakhevsvzhsbqpfx-kkb552a465
export GROQ_API_BASE=https://kodekey.ai.kodekloud.com
export AZURE_OPENAI_API_KEY=Sk-kkAI-d992386444e314dc9156dfce8f082706ec124573ad36a0b103515cf8615d3799kk_hakhevsvzhsbqpfx-kkb552a465
export CLAUDE_API_BASE=https://kodekey.ai.kodekloud.com
