FROM nvcr.io/nvidia/pytorch:24.06-py3

ENV PATH=/opt/conda/bin:$PATH

RUN apt-get update && apt-get install -y \
    libgl1-mesa-glx \
    libglib2.0-0 \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

RUN curl https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -o ~/miniconda.sh \
    && sh ~/miniconda.sh -b -p /opt/conda \
    && rm ~/miniconda.sh

RUN wget https://github.com/nazdridoy/kokoro-tts/releases/download/v1.0.0/voices-v1.0.bin
RUN wget https://github.com/nazdridoy/kokoro-tts/releases/download/v1.0.0/kokoro-v1.0.onnx


COPY ./requirements.txt /app/requirements.txt

RUN pip install -r requirements.txt

COPY . /app



ENV HF_HOME=/huggingface

ENV GRADIO_SERVER_NAME=0.0.0.0

#1.5
CMD ["python", "-u", "-W", "ignore", "app.py", "--share", "--device", "cuda"]
#python -u -W ignore app/app_sana.py --share --config=configs/sana1-5_config/1024ms/Sana_1600M_1024px_allqknorm_bf16_lr2e5.yaml --model_path=hf://Efficient-Large-Model/SANA1.5_1.6B_1024px/checkpoints/SANA1.5_1.6B_1024px.pth

EXPOSE 7860
