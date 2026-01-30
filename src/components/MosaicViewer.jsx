export default function MosaicViewer({ tokenURI }) {
  if (!tokenURI) return null;
  try {
    const base64Json = tokenURI.split(",")[1];
    const metadata = JSON.parse(atob(base64Json));
    const image = metadata.image;
    return (
      <div className="mt-4 border border-gray-700 rounded-lg p-3 bg-gray-900">
        <img
          src={image}
          alt="ChainMosaic"
          className="w-64 h-64 rounded-md shadow-lg"
        />
        <p className="text-center text-gray-400 mt-2 text-sm">
          {metadata.name}
        </p>
      </div>
    );
  } catch {
    return <p className="text-red-400">Invalid token data</p>;
  }
}
