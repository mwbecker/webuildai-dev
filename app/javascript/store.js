import { createStore, applyMiddleware } from 'redux';
import thunk from 'redux-thunk';
import { persistStore, persistReducer } from 'redux-persist';
import storage from 'redux-persist/lib/storage';
import autoMergeLevel2 from 'redux-persist/lib/stateReconciler/autoMergeLevel2';
import { composeWithDevTools } from 'redux-devtools-extension';

const INITIAL_STATE = {
    things: "",
    rankedListState: {
        category: "request", // or "driver"
        round: 0,
        pairwiseComparisons: []
    }
};

export const ACTION_TYPES = {
    SET_PAIRWISE_COMPARISONS: 'SET_PAIRWISE_COMPARISONS', // value can be anything
};

const rootReducer = (state, action) => {
    console.log("incoming action:", action);
    switch (action.type) {
        case 'GET_THINGS_SUCCESS':
            return { ...state, things: action.data.polo }
        case ACTION_TYPES.SET_PAIRWISE_COMPARISONS:
            return { ...state, rankedListState: { ...action.data } }
        default:
            return state;
    }
}

const persistConfig = {
    key: 'root',
    storage: storage,
    stateReconciler: autoMergeLevel2, // see "Merge Process" section for details.
    whitelist: ['rankedListState']
};
const pReducer = persistReducer(persistConfig, rootReducer);

export const store = createStore(rootReducer, INITIAL_STATE, composeWithDevTools(applyMiddleware(thunk)));
export const persistor = persistStore(store);