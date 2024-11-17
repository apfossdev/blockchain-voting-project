import { Routes, Route, Navigate, useNavigate, useLocation } from "react-router-dom";
import { useAccount } from "wagmi";
import { useEffect } from "react";
import AdminPage from "./AdminPage";
import UserPage from "./UserPage";
import HomePage from "./HomePage";
import CreateElectionPage from "./CreateElectionPage";
import ViewElectionsPage from "./ViewElectionsPage";

const AppRoutes = () => {
  const { address, isConnected } = useAccount();
  const navigate = useNavigate();
  const location = useLocation(); // for hook to check the current path
  const adminWalletAddress = "0xD1f6Ca8adE0962A6b172c4c03ae088329d9FdD9f";

  useEffect(() => {
    // Only redirect if we're on the homepage or if disconnected
    if (location.pathname === "/" || !isConnected) {
        if(!isConnected) {
            navigate("/");
        }
        else if (isConnected && address === adminWalletAddress) {
            navigate("/admin");
        } else if (isConnected && address !== adminWalletAddress) {
            navigate("/user");
        }
    }
  }, [isConnected, address, navigate, location.pathname]);

  // Helper function to check if user is admin
  const isAdmin = isConnected && address === adminWalletAddress;

  return (
    <Routes>
      <Route path="/" element={<HomePage />} />
      <Route
        path="/admin"
        element={isAdmin ? <AdminPage /> : <Navigate to="/" />}
      />
      <Route
        path="/user"
        element={
          isConnected && address !== adminWalletAddress ? (
            <UserPage />
          ) : (
            <Navigate to="/" />
          )
        }
      />
      <Route
        path="/admin/create-election"
        element={isAdmin ? <CreateElectionPage /> : <Navigate to="/" />}
      />
      <Route
        path="/view-elections"
        element={<ViewElectionsPage />}
      />
    </Routes>
  );
};

export default AppRoutes;
