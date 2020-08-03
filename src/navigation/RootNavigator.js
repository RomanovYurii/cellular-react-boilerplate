import React from 'react';
import { Router } from '@reach/router';
import App from '../components/4_ecosystems/App';

const RootNavigator = () => {
	return (
		<Router>
			<App path="/" />
		</Router>
	);
};

export default RootNavigator;
