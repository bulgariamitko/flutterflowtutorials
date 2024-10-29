# R2 File Upload Worker

A Cloudflare Worker that handles file uploads to R2 storage with a simple API interface.

## Setup Instructions

### 1. Create R2 Bucket

1. Go to Cloudflare Dashboard > R2
2. Click "Create Bucket"
3. Give your bucket a name (e.g., "quickclip")
4. Click "Create Bucket"

### 2. Create Worker

1. Go to Cloudflare Dashboard > Workers & Pages
2. Click "Create Application"
3. Select "Create Worker"
4. Give your worker a name (e.g., "r2-upload-files")

### 3. Configure R2 Binding

1. In your Worker's settings, go to the "Settings" tab
2. Under "Bindings" section, click "Add binding"
3. Select "R2 bucket" as the binding type
4. Configure the binding:
   - Variable name: `myBucket` (This must match the variable name in your code)
   - R2 bucket: Select your created bucket
5. Click "Save"

### 4. Configure Custom Domain (Optional)

1. In your Worker's settings, go to "Domains & Routes"
2. Click "Add domain"
3. Enter your desired domain (e.g., "r2-upload-files.yourdomain.workers.dev")
4. Click "Add domain"

## Code Implementation

### Worker Code

```javascript
export default {
  async fetch(request, env, ctx) {
    // ... [Previous worker code here]
    try {
      await env.myBucket.put(uniqueName, file.stream(), {
        httpMetadata: {
          contentType: file.type,
        },
      });
    }
    // ... [Rest of the code]
  }
};
```

## API Usage

### Upload a File

```bash
curl --request POST \
  --url https://YOUR_WORKER_URL.workers.dev/ \
  --header 'content-type: multipart/form-data' \
  --form file=@/path/to/your/file.png
```

Replace:

- `YOUR_WORKER_URL` with your worker's URL
- `/path/to/your/file.png` with the path to the file you want to upload

### Successful Response

```json
{
  "success": true,
  "url": "https://YOUR_R2_BUCKET_URL/1234567890-abcdef.png",
  "filename": "1234567890-abcdef.png",
  "originalName": "example.png",
  "type": "image/png"
}
```

### Error Response

```json
{
  "error": "Error message",
  "details": "Detailed error information"
}
```

## Environment Variables

The worker uses the following bindings:

- `myBucket`: R2 bucket binding for file storage

## CORS Configuration

The worker is configured to handle CORS requests with the following settings:

- Allowed origins: `*` (all origins)
- Allowed methods: `POST`
- Allowed headers: `Content-Type`

## Important Notes

1. Make sure your R2 bucket name matches the one in your binding configuration
2. The maximum file size limit is determined by your Cloudflare plan
3. The worker generates unique filenames using timestamp and random string
4. File types are automatically detected and stored with correct content-type

## Security Considerations

1. No authentication is implemented in this basic example
2. Consider adding:
   - API key validation
   - File type restrictions
   - File size limits
   - Rate limiting
   - Custom CORS origins

## Development

To modify the worker:

1. Clone this repository
2. Install Wrangler CLI: `npm install -g wrangler`
3. Login to Cloudflare: `wrangler login`
4. Make your changes
5. Deploy: `wrangler publish`

## Troubleshooting

Common issues:

1. **403 Error**: Check your R2 bucket bindings
2. **500 Error**: Verify R2 bucket permissions
3. **413 Error**: File size too large

## Support

For issues and questions:

1. Check Cloudflare Workers documentation
2. Review R2 storage documentation
3. Create an issue in this repository
