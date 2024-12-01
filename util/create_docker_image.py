import subprocess
import os
from dotenv import load_dotenv

def build_docker_image(image_name, dockerfile_path="."):
    command = ["docker", "build", "-t", image_name, dockerfile_path]
    try:
        result = subprocess.run(command, check=True, capture_output=True, text=True)
        print(f"Docker image '{image_name}' built successfully!\n{result.stdout}")
        print(f"Command run: {' '.join(command)}")
    except subprocess.CalledProcessError as e:
        print(f"Error during Docker build: {e.stderr}")
        print(f"Command run: {' '.join(command)}")

def push_docker_image(image_name):
    try:
        result = subprocess.run(["docker", "push", image_name], check=True, capture_output=True, text=True)
        print(f"Docker image '{image_name}' pushed successfully!\n{result.stdout}")
    except subprocess.CalledProcessError as e:
        print(f"Error during Docker push: {e.stderr}")

if __name__ == "__main__":
    load_dotenv("config/.env")
    
    image_name = os.getenv("DOCKER_IMAGE_NAME", "unnamed")
    dockerfile_path = os.getenv("DOCKERFILE_PATH", ".")
    build_docker_image(image_name, dockerfile_path)
    #push_docker_image(image_name)
