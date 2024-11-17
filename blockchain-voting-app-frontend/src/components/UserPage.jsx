import { ConnectButton } from "@rainbow-me/rainbowkit";

const UserPage = () => {
  return (
    <div className="min-h-screen bg-gray-100">
      <header className="bg-white shadow-sm">
        <div className="max-w-7xl mx-auto px-4 py-4 sm:px-6 lg:px-8 flex justify-between items-center">
          <h1 className="text-2xl font-bold">Blockchain Voting App</h1>
          <ConnectButton />
        </div>
      </header>
      <main className="max-w-7xl mx-auto px-4 py-8 sm:px-6 lg:px-8">
        <div className="bg-white shadow rounded-lg p-6">
          <h2 className="text-2xl font-semibold mb-4">User Dashboard</h2>
          {/* Add user-specific content here */}
        </div>
      </main>
    </div>
  );
};

export default UserPage;
