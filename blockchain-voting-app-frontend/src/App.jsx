import "@rainbow-me/rainbowkit/styles.css";
import { getDefaultConfig, RainbowKitProvider } from "@rainbow-me/rainbowkit";
import { WagmiProvider, useAccount } from "wagmi"; //wagmi hook useAccount
import { mainnet, sepolia, polygon, optimism, arbitrum, base } from "wagmi/chains";
import { QueryClientProvider, QueryClient } from "@tanstack/react-query";
import { BrowserRouter as Router } from "react-router-dom";
import AppRoutes from "./components/AppRoutes";

const config = getDefaultConfig({
  appName: "My RainbowKit App",
  projectId: "b5bcc8ed11012dc38f1bfcb9fc4663a3",
  chains: [mainnet, sepolia, polygon, optimism, arbitrum, base],
  ssr: false, // If your dApp uses server side rendering (SSR) set it to true
}); 

const queryClient = new QueryClient();

const App = () => {

  return (
    <WagmiProvider config={config}>
      <QueryClientProvider client={queryClient}>
        <RainbowKitProvider coolMode>
            <Router>
              <AppRoutes />
            </Router>
        </RainbowKitProvider>
      </QueryClientProvider>
    </WagmiProvider>
  );
};

export default App
