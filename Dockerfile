FROM python:3.9-slim

# Set the working directory in the container
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app/

# Install pipenv
RUN pip install pipenv

# Install dependencies from the Pipfile
RUN pipenv install --dev --python 3.9

# Install missing dependencies explicitly, including Pillow
RUN pipenv install typing-extensions pillow

# Expose port 7005 to access the Django development server
EXPOSE 7005

# Run the Django development server when the container starts
CMD ["pipenv", "run", "python", "manage.py", "runserver", "0.0.0.0:7005"]
