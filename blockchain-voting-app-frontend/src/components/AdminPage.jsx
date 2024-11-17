import { ConnectButton } from "@rainbow-me/rainbowkit";
import { useNavigate } from "react-router-dom";

const AdminPage = () => {
  const navigate = useNavigate();

  const handleCreateElection = () => {
    //Navigate to create election route
    navigate("/admin/create-election");
  };
  
  const handleViewElections = () => {
    //Navigate to view elections route
    navigate("/view-elections");
  };

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
          <h2 className="text-2xl font-semibold mb-4">Admin Dashboard</h2>
          {/* Add admin-specific content here */}
          <div class="flex justify-center items-center gap-4">
            <button
              class="bg-gray-200 hover:bg-gray-300 text-gray-800 font-bold py-2 px-4 rounded border border-gray-300"
              onClick={handleCreateElection}
            >
              Create New Election
            </button>
            <button 
            class="bg-gray-200 hover:bg-gray-300 text-gray-800 font-bold py-2 px-4 rounded border border-gray-300"
            onClick={handleViewElections}
            >
              View all Elections
            </button>
          </div>
        </div>
      </main>
    </div>
  );
};

export default AdminPage;
