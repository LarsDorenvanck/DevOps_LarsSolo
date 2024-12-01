import subprocess
import os
from dotenv import load_dotenv

def run_docker_compose(compose_file_path="."):
    command = ["docker-compose", "-f", compose_file_path, "up", "-d"]
    try:
        result = subprocess.run(command, check=True, capture_output=True, text=True)
        print(f"Docker Compose started successfully!\n{result.stdout}")
        print(f"Command run: {' '.join(command)}")
    except subprocess.CalledProcessError as e:
        print(f"Error during Docker Compose up: {e.stderr}")
        print(f"Command run: {' '.join(command)}")

if __name__ == "__main__":
    load_dotenv("config/.env")
    
    compose_file_path = os.getenv("DOCKER_COMPOSE_FILE_PATH", "docker-compose.yml")
    run_docker_compose(compose_file_path)
