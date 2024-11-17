import { ConnectButton } from "@rainbow-me/rainbowkit";
import { useNavigate } from "react-router-dom";
import { useState } from "react";

const CreateElectionPage = () => {
  const navigate = useNavigate();
  const handleBack = () => {
    navigate("/admin");
  };

  const [electionName, setElectionName] = useState("");
  const [electionDuration, setElectionDuration] = useState("");
  const [electionArrayOfCandidates, setElectionArrayOfCandidates] = useState([]);

  const handleCandidateInput = (e) => {

    if(e.target.value.trim === "") {
      setElectionArrayOfCandidates([]);
      return;
    }

    const newCandidates = e.target.value.split(",").map((candidateName) => candidateName.trim());
    setElectionArrayOfCandidates(newCandidates);
  };

  const handleSubmit = (e) => {
    e.preventDefault();
    console.log(electionName, electionDuration, electionArrayOfCandidates); // all are in string datatypes
    // TODO: Add logic to create election to contract
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
            <h2 className="text-2xl font-semibold">Create Election</h2>
          </div>
        </div>
        <div>
          {/* Add your election creation form here */}
          <form action="">
            <div className="flex justify-center items-center gap-4 bg-white shadow rounded-lg p-6">
              <label for="name">Election Name:</label>
              <input
                type="text"
                id="name"
                name="name"
                placeholder="Enter Election Name"
                value={electionName}
                onChange={(e) => setElectionName(e.target.value)}
              />
              <label for="duration">Duration (in seconds):</label>
              <input
                type="number"
                id="duration"
                name="duration"
                placeholder="Enter Duration"
                value={electionDuration}
                onChange={(e) => setElectionDuration(e.target.value)}
              />
              <label for="arrayOfCandidates">Candidates:</label>
              <input
                type="text"
                name="arrayOfCandidates"
                placeholder="Enter Candidate Names (separated by commas)"
                value={electionArrayOfCandidates.join(",")}
                onChange={handleCandidateInput}
              />
              <button
                className="bg-gray-200 hover:bg-gray-300 text-gray-800 font-bold py-2 px-4 rounded border border-gray-300"
                onClick={handleSubmit}
              >
                Create Election
              </button>
            </div>
          </form>
        </div>
      </main>
    </div>
  );
};

export default CreateElectionPage;
