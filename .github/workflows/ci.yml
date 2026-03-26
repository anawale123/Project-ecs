name: Automating image push to AWS ECR with OIDC

on: [push]

jobs:
  build-and-publish:
    runs-on: ubuntu-latest

    permissions:
      id-token: write
      contents: read

    env:
      AWS_ACCOUNT_ID: 111810594106
      AWS_REGION: eu-west-2

    steps:
      - name: Checkout repo
        uses: actions/checkout@v3

      - name: Configure AWS via OIDC
        uses: aws-actions/configure-aws-credentials@v2
        with:
          role-to-assume: arn:aws:iam::111810594106:role/ecs-push
          aws-region: ${{ env.AWS_REGION }}

      - name: Login to Amazon ECR
        run: |
          aws ecr get-login-password --region $AWS_REGION \
          | docker login --username AWS --password-stdin $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com

      # UMAMI IMAGE
      - name: Build image (umami)
        run: |
          docker build --cache-from=type=gha --cache-to=type=gha,mode=max -f umami/Dockerfile -t umami:latest umami/

      - name: Scan image (umami)
        uses: aquasecurity/trivy-action@v0.20.0
        with:
          image-ref: umami:latest
          severity: HIGH,CRITICAL
          exit-code: 1

      - name: Push image (umami)
        run: |
          registry="$AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/image_umami"
          sha=$(git rev-parse --short HEAD)
          primary_tag="${registry}:${sha}"

          docker tag umami:latest $primary_tag
          docker push $primary_tag

          current_branch=$(git rev-parse --abbrev-ref HEAD)
          if [ "$current_branch" = "main" ]; then
            latest_tag="${registry}:latest"
            docker tag umami:latest $latest_tag
            docker push $latest_tag
          fi

      # URL SHORTENER IMAGE
      - name: Build image (url_shortner)
        run: |
          docker build --cache-from=type=gha --cache-to=type=gha,mode=max -f umami/url-shortner/Dockerfile -t url_shortner:latest umami/url-shortner

      - name: Scan image (url_shortner)
        uses: aquasecurity/trivy-action@v0.20.0
        with:
          image-ref: url_shortner:latest
          severity: HIGH,CRITICAL
          exit-code: 1

      - name: Push image (url_shortner)
        run: |
          registry="$AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/url_shortner"
          sha=$(git rev-parse --short HEAD)
          primary_tag="${registry}:${sha}"

          docker tag url_shortner:latest $primary_tag
          docker push $primary_tag

          current_branch=$(git rev-parse --abbrev-ref HEAD)
          if [ "$current_branch" = "main" ]; then
            latest_tag="${registry}:latest"
            docker tag url_shortner:latest $latest_tag
            docker push $latest_tag
          fi
