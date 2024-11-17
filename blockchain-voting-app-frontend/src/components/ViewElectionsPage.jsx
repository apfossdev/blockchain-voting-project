import { ConnectButton } from "@rainbow-me/rainbowkit";
import { useNavigate } from "react-router-dom";
import { useEffect, useState } from "react";

// TODO: Add logic to fetch all elections from contract

const ViewElectionsPage = () => {
  const navigate = useNavigate();

  // Navigate to admin page
  const handleBack = () => {
    navigate("/admin");
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
          <div className="flex items-center mb-4">
            <button
              onClick={handleBack}
              className="mr-4 text-gray-600 hover:text-gray-900"
            >
              ← Back
            </button>
            <h2 className="text-2xl font-semibold">View all Elections</h2>
          </div>
          {/* Add your election names here */}
        </div>
      </main>
    </div>
  );
};

export default ViewElectionsPage;
