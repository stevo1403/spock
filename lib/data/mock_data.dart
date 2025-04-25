import '../models/wallet.dart';
import '../models/token.dart';
import '../models/transaction.dart';
import '../models/nft.dart';
import '../models/dapp.dart';

class MockData {
  static List<Wallet> getWallets() {
    return [
      Wallet(
        id: '1',
        name: 'MetaMask',
        address: '0x71C7656EC7ab88b098defB751B7401B5f6d8976F',
        shortAddress: '0x71C7...976F',
        balance: '1.245 ETH',
        icon: 'https://upload.wikimedia.org/wikipedia/commons/3/36/MetaMask_Fox.svg',
        chainId: 1,
        network: 'Ethereum Mainnet',
      ),
      Wallet(
        id: '2',
        name: 'Coinbase Wallet',
        address: '0x8ba1f109551bD432803012645Ac136ddd64DBA72',
        shortAddress: '0x8ba1...BA72',
        balance: '0.587 ETH',
        icon: 'https://seeklogo.com/images/C/coinbase-coin-logo-C86F46D7B8-seeklogo.com.png',
        chainId: 1,
        network: 'Ethereum Mainnet',
      ),
      Wallet(
        id: '3',
        name: 'Trust Wallet',
        address: '0xc778417E063141139Fce010982780140Aa0cD5Ab',
        shortAddress: '0xc778...D5Ab',
        balance: '2.103 ETH',
        icon: 'https://trustwallet.com/assets/images/media/assets/TWT.png',
        chainId: 1,
        network: 'Ethereum Mainnet',
      ),
      Wallet(
        id: '4',
        name: 'Rainbow',
        address: '0xdD2FD4581271e230360230F9337D5c0430Bf44C0',
        shortAddress: '0xdD2F...44C0',
        balance: '0.842 ETH',
        icon: 'https://rainbowkit.com/rainbow.svg',
        chainId: 1,
        network: 'Ethereum Mainnet',
      ),
    ];
  }

  static List<Message> getMessages() {
    return [
      Message(
        id: '1',
        title: 'Welcome to MyWallet',
        content: 'Thank you for connecting your wallet. Explore the latest DeFi opportunities and stay updated with market trends.',
        timestamp: DateTime.now().subtract(const Duration(minutes: 5)).millisecondsSinceEpoch,
        read: false,
      ),
      Message(
        id: '2',
        title: 'Security Alert',
        content: 'We detected a new login to your wallet. If this was not you, please secure your account immediately.',
        timestamp: DateTime.now().subtract(const Duration(minutes: 30)).millisecondsSinceEpoch,
        read: true,
      ),
      Message(
        id: '3',
        title: 'New Token Listing',
        content: 'A new token has been listed on major exchanges. Check out the details and trading opportunities.',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)).millisecondsSinceEpoch,
        read: true,
      ),
      Message(
        id: '4',
        title: 'Governance Vote',
        content: 'An important governance proposal is now open for voting. Make your voice heard in the community.',
        timestamp: DateTime.now().subtract(const Duration(days: 1)).millisecondsSinceEpoch,
        read: true,
      ),
    ];
  }

  static List<Advertisement> getAdvertisements() {
    return [
      Advertisement(
        id: '1',
        title: 'Climb the Leaderboard & EARN BIG',
        description: 'Limited Time Opportunity! Join Now!',
        imageUrl: 'https://images.unsplash.com/photo-1639762681057-408e52192e55?q=80&w=2832&auto=format&fit=crop',
        ctaText: 'Join Now',
        ctaUrl: 'https://example.com/promo1',
      ),
      Advertisement(
        id: '2',
        title: 'New DeFi Protocol Launch',
        description: 'Get early access to the hottest new DeFi protocol',
        imageUrl: 'https://images.unsplash.com/photo-1621761191319-c6fb62004040?q=80&w=2787&auto=format&fit=crop',
        ctaText: 'Learn More',
        ctaUrl: 'https://example.com/promo2',
      ),
      Advertisement(
        id: '3',
        title: 'NFT Collection Drop',
        description: 'Exclusive NFT collection dropping this weekend',
        imageUrl: 'https://images.unsplash.com/photo-1620321023374-d1a68fbc720d?q=80&w=2897&auto=format&fit=crop',
        ctaText: 'View Collection',
        ctaUrl: 'https://example.com/promo3',
      ),
    ];
  }

  static List<Exchange> getExchanges() {
    return [
      Exchange(
        id: '1',
        name: 'Uniswap',
        description: 'Ethereum-Based DEX',
        icon: 'https://cryptologos.cc/logos/uniswap-uni-logo.png',
        url: 'https://uniswap.org',
        type: 'DEX',
      ),
      Exchange(
        id: '2',
        name: 'Pancake Swap',
        description: 'AMM Decentralized Exchange',
        icon: 'https://cryptologos.cc/logos/pancakeswap-cake-logo.png',
        url: 'https://pancakeswap.finance',
        type: 'DEX',
      ),
      Exchange(
        id: '3',
        name: '1inch Exchange',
        description: 'Cryptocurrency Trading Platform',
        icon: 'https://cryptologos.cc/logos/1inch-1inch-logo.png',
        url: 'https://1inch.io',
        type: 'DEX Aggregator',
      ),
      Exchange(
        id: '4',
        name: 'Sushi',
        description: 'Ethereum-Based DEX',
        icon: 'https://cryptologos.cc/logos/sushiswap-sushi-logo.png',
        url: 'https://sushi.com',
        type: 'DEX',
      ),
      Exchange(
        id: '5',
        name: 'Binance',
        description: 'Crypto Exchange & Trading Platform',
        icon: 'https://cryptologos.cc/logos/binance-coin-bnb-logo.png',
        url: 'https://binance.com',
        type: 'CEX',
      ),
    ];
  }

  static List<Token> getTokens() {
    return [
      Token(
        name: 'Ethereum',
        symbol: 'ETH',
        decimals: 18,
        address: '0xeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee',
        logoURI: 'https://assets.coingecko.com/coins/images/279/small/ethereum.png',
        chainId: 1,
        tags: ['native', 'ethereum'],
      ),
      Token(
        name: 'Tether USD',
        symbol: 'USDT',
        decimals: 6,
        address: '0xdAC17F958D2ee523a2206206994597C13D831ec7',
        logoURI: 'https://assets.coingecko.com/coins/images/325/small/Tether.png',
        chainId: 1,
        tags: ['stablecoin'],
      ),
      Token(
        name: 'USD Coin',
        symbol: 'USDC',
        decimals: 6,
        address: '0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48',
        logoURI: 'https://assets.coingecko.com/coins/images/6319/small/USD_Coin_icon.png',
        chainId: 1,
        tags: ['stablecoin'],
      ),
      Token(
        name: 'Shiba Inu',
        symbol: 'SHIB',
        decimals: 18,
        address: '0x95aD61b0a150d79219dCF64E1E6Cc01f0B64C4cE',
        logoURI: 'https://assets.coingecko.com/coins/images/11939/small/shiba.png',
        chainId: 1,
        tags: ['meme', 'deflationary'],
      ),
    ];
  }

  static List<TokenBalance> getTokenBalances(String address) {
    final tokens = getTokens();
    
    return tokens.map((token) {
      final randomBalance = (token.symbol == 'SHIB') 
          ? (1000000 + (5000000 * (address.hashCode % 10))).toStringAsFixed(0)
          : (0.1 + (5 * (address.hashCode % 10) / 10)).toStringAsFixed(token.decimals > 8 ? 8 : 4);
      
      final randomPrice = token.symbol == 'ETH' 
          ? (1800 + (address.hashCode % 500)).toStringAsFixed(2) 
          : token.symbol == 'USDT' || token.symbol == 'USDC'
              ? '1.00'
              : (0.00001 + (address.hashCode % 100) / 10000000).toStringAsFixed(8);
      
      final balanceUsd = (double.parse(randomBalance) * double.parse(randomPrice)).toStringAsFixed(2);
      final priceChange24h = ((address.hashCode % 20) - 10).toStringAsFixed(2);
      
      return TokenBalance(
        token: token,
        balance: randomBalance,
        balanceUsd: '\$$balanceUsd',
        price: '\$$randomPrice',
        priceChange24h: '$priceChange24h%',
      );
    }).toList();
  }

  static List<Transaction> getTransactions(String address) {
    return [
      Transaction(
        id: '1',
        type: 'send',
        status: 'completed',
        amount: '0.5',
        token: 'Ethereum',
        tokenSymbol: 'ETH',
        timestamp: DateTime.now().subtract(const Duration(minutes: 30)).millisecondsSinceEpoch,
        from: address,
        to: '0x1234567890abcdef1234567890abcdef12345678',
        hash: '0xabcdef1234567890abcdef1234567890abcdef1234567890abcdef1234567890',
        fee: '0.002 ETH',
      ),
      Transaction(
        id: '2',
        type: 'receive',
        status: 'completed',
        amount: '100',
        token: 'USD Coin',
        tokenSymbol: 'USDC',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)).millisecondsSinceEpoch,
        from: '0x0987654321fedcba0987654321fedcba09876543',
        to: address,
        hash: '0x0987654321fedcba0987654321fedcba0987654321fedcba0987654321fedcba',
        fee: '0.001 ETH',
      ),
      Transaction(
        id: '3',
        type: 'swap',
        status: 'completed',
        amount: '200',
        token: 'Tether USD',
        tokenSymbol: 'USDT',
        timestamp: DateTime.now().subtract(const Duration(hours: 24)).millisecondsSinceEpoch,
        from: address,
        to: '0x5678901234abcdef5678901234abcdef56789012',
        hash: '0x5678901234abcdef5678901234abcdef5678901234abcdef5678901234abcdef',
        fee: '0.003 ETH',
      ),
      Transaction(
        id: '4',
        type: 'approve',
        status: 'completed',
        amount: 'Unlimited',
        token: 'Shiba Inu',
        tokenSymbol: 'SHIB',
        timestamp: DateTime.now().subtract(const Duration(days: 2)).millisecondsSinceEpoch,
        from: address,
        to: '0xabcdef1234567890abcdef1234567890abcdef12',
        hash: '0xfedcba0987654321fedcba0987654321fedcba0987654321fedcba0987654321',
        fee: '0.0015 ETH',
      ),
      Transaction(
        id: '5',
        type: 'send',
        status: 'pending',
        amount: '0.1',
        token: 'Ethereum',
        tokenSymbol: 'ETH',
        timestamp: DateTime.now().subtract(const Duration(minutes: 10)).millisecondsSinceEpoch,
        from: address,
        to: '0x2468013579abcdef2468013579abcdef24680135',
        hash: '0x13579bdf2468ace13579bdf2468ace13579bdf2468ace13579bdf2468ace1357',
        fee: '0.0025 ETH',
      ),
    ];
  }

  static List<NFT> getNFTs() {
    return [
      NFT(
        id: '1',
        name: 'Abstract Dimensions #024',
        collection: 'Abstract Dimensions',
        image: 'https://images.unsplash.com/photo-1618005182384-a83a8bd57fbe?q=80&w=2564&auto=format&fit=crop',
        price: '0.45',
        currency: 'ETH',
        creator: 'ArtistOne',
        likes: 128,
        isLiked: false,
      ),
      NFT(
        id: '2',
        name: 'Cosmic Voyager #103',
        collection: 'Cosmic Voyagers',
        image: 'https://images.unsplash.com/photo-1614730321146-b6fa6a46bcb4?q=80&w=2574&auto=format&fit=crop',
        price: '1.2',
        currency: 'ETH',
        creator: 'SpaceCreator',
        likes: 256,
        isLiked: true,
      ),
      NFT(
        id: '3',
        name: 'Digital Bloom #057',
        collection: 'Digital Blooms',
        image: 'https://images.unsplash.com/photo-1608501078713-8e445a709b39?q=80&w=2574&auto=format&fit=crop',
        price: '0.75',
        currency: 'ETH',
        creator: 'NatureDigital',
        likes: 89,
        isLiked: false,
      ),
      NFT(
        id: '4',
        name: 'Neon Dreams #212',
        collection: 'Neon Dreams',
        image: 'https://images.unsplash.com/photo-1634986666676-ec8fd927c23d?q=80&w=2574&auto=format&fit=crop',
        price: '0.35',
        currency: 'ETH',
        creator: 'NeonArtist',
        likes: 145,
        isLiked: false,
      ),
      NFT(
        id: '5',
        name: 'Pixel Warriors #078',
        collection: 'Pixel Warriors',
        image: 'https://images.unsplash.com/photo-1618172193622-ae2d025f4032?q=80&w=2564&auto=format&fit=crop',
        price: '0.6',
        currency: 'ETH',
        creator: 'PixelMaster',
        likes: 210,
        isLiked: true,
      ),
      NFT(
        id: '6',
        name: 'Ethereal Landscapes #045',
        collection: 'Ethereal Landscapes',
        image: 'https://images.unsplash.com/photo-1633186223008-25a1c7e5f866?q=80&w=2574&auto=format&fit=crop',
        price: '0.9',
        currency: 'ETH',
        creator: 'DreamScaper',
        likes: 178,
        isLiked: false,
      ),
    ];
  }

  static List<NFTCollection> getNFTCollections() {
    return [
      NFTCollection(
        id: '1',
        name: 'Abstract Dimensions',
        image: 'https://images.unsplash.com/photo-1618005182384-a83a8bd57fbe?q=80&w=2564&auto=format&fit=crop',
        floorPrice: '0.45',
        currency: 'ETH',
        volume: '120.5',
        items: 1000,
      ),
      NFTCollection(
        id: '2',
        name: 'Cosmic Voyagers',
        image: 'https://images.unsplash.com/photo-1614730321146-b6fa6a46bcb4?q=80&w=2574&auto=format&fit=crop',
        floorPrice: '1.2',
        currency: 'ETH',
        volume: '350.8',
        items: 750,
      ),
      NFTCollection(
        id: '3',
        name: 'Digital Blooms',
        image: 'https://images.unsplash.com/photo-1608501078713-8e445a709b39?q=80&w=2574&auto=format&fit=crop',
        floorPrice: '0.75',
        currency: 'ETH',
        volume: '89.2',
        items: 500,
      ),
      NFTCollection(
        id: '4',
        name: 'Neon Dreams',
        image: 'https://images.unsplash.com/photo-1634986666676-ec8fd927c23d?q=80&w=2574&auto=format&fit=crop',
        floorPrice: '0.35',
        currency: 'ETH',
        volume: '45.6',
        items: 1200,
      ),
    ];
  }

  static List<DApp> getDApps() {
    return [
      DApp(
        id: '1',
        name: 'Uniswap',
        description: 'Swap and provide liquidity for tokens',
        category: 'DeFi',
        icon: 'https://cryptologos.cc/logos/uniswap-uni-logo.png',
        url: 'https://app.uniswap.org',
        featured: true,
      ),
      DApp(
        id: '2',
        name: 'OpenSea',
        description: 'NFT marketplace for digital collectibles',
        category: 'NFT',
        icon: 'https://storage.googleapis.com/opensea-static/Logomark/Logomark-Blue.png',
        url: 'https://opensea.io',
        featured: true,
      ),
      DApp(
        id: '3',
        name: 'Aave',
        description: 'Lending and borrowing protocol',
        category: 'DeFi',
        icon: 'https://cryptologos.cc/logos/aave-aave-logo.png',
        url: 'https://app.aave.com',
        featured: false,
      ),
      DApp(
        id: '4',
        name: 'Axie Infinity',
        description: 'Play-to-earn NFT game',
        category: 'Gaming',
        icon: 'https://cryptologos.cc/logos/axie-infinity-axs-logo.png',
        url: 'https://axieinfinity.com',
        featured: false,
      ),
      DApp(
        id: '5',
        name: 'Lens Protocol',
        description: 'Decentralized social media platform',
        category: 'Social',
        icon: 'https://lens.xyz/static/logo.svg',
        url: 'https://lens.xyz',
        featured: true,
      ),
      DApp(
        id: '6',
        name: 'Compound',
        description: 'Algorithmic money markets',
        category: 'DeFi',
        icon: 'https://cryptologos.cc/logos/compound-comp-logo.png',
        url: 'https://app.compound.finance',
        featured: false,
      ),
      DApp(
        id: '7',
        name: 'Rarible',
        description: 'Create and sell digital collectibles',
        category: 'NFT',
        icon: 'https://cryptologos.cc/logos/rarible-rari-logo.png',
        url: 'https://rarible.com',
        featured: false,
      ),
      DApp(
        id: '8',
        name: 'Decentraland',
        description: 'Virtual reality platform',
        category: 'Gaming',
        icon: 'https://cryptologos.cc/logos/decentraland-mana-logo.png',
        url: 'https://decentraland.org',
        featured: false,
      ),
    ];
  }

  static Message generateNewMessage() {
    return Message(
      id: 'new-${DateTime.now().millisecondsSinceEpoch}',
      title: 'New Market Update',
      content: 'The market is showing positive trends. Check your portfolio for potential gains.',
      timestamp: DateTime.now().millisecondsSinceEpoch,
      read: false,
    );
  }
}