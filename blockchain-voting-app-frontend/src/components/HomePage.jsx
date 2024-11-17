import { ConnectButton } from "@rainbow-me/rainbowkit";

const HomePage = () => {
  return (
    <div className="min-h-screen flex flex-col items-center justify-center bg-gray-100">
      <h1 className="text-4xl font-bold mb-8">Blockchain Voting App</h1>
      <ConnectButton />
    </div>
  );
};

export default HomePage;
