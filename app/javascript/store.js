import { createStore, applyMiddleware } from 'redux';
import thunk from 'redux-thunk';
import { persistStore, persistReducer } from 'redux-persist';
import storage from 'redux-persist/lib/storage';
import autoMergeLevel2 from 'redux-persist/lib/stateReconciler/autoMergeLevel2';
import { composeWithDevTools } from 'redux-devtools-extension';

const INITIAL_STATE = {
    things: "",
    category: "request", // or "driver"
    pairwiseComparisons: [],
    round: 0,
    model: {
        url: "",
        weights: []
    },
    rankedList: [],
    ranklistId: 0,
};

export const ACTION_TYPES = {
    SET_PAIRWISE_COMPARISONS: 'SET_PAIRWISE_COMPARISONS', // value can be anything
    SET_RANKED_LIST: 'SET_RANKLIST', // value can be anything
    SET_ML_SERVER_URL: 'SET_ML_SERVER_MODEL', // value can be anything
    SET_MODEL_WEIGHTS: 'SET_ML_MODEL_WEIGHTS',
    SET_RANKED_LIST: 'SET_RANKED_LIST',
    SET_ROUND: 'SET_ROUND',
    SET_CATEGORY: 'SET_CATEGORY',
    END_RL_FLOW: 'END_RL_FLOW',
    SET_RANKLIST_ID: 'SET_RANKLIST_ID',
};

const rootReducer = (state, action) => {
    console.log("incoming action:", action);
    const payload = action.payload;
    const oldState = { ...state };
    switch (action.type) {
        case 'GET_THINGS_SUCCESS':
            return { ...state, things: payload.polo }
        case ACTION_TYPES.SET_PAIRWISE_COMPARISONS:
            return { ...state, pairwiseComparisons: payload }
        case ACTION_TYPES.SET_ML_SERVER_URL:
            oldState.model.url = payload;
            return oldState;
        case ACTION_TYPES.SET_MODEL_WEIGHTS:
            oldState.model.weights = payload;
            return oldState;
        case ACTION_TYPES.SET_RANKED_LIST:
            oldState.rankedList = payload;
            return oldState;
        case ACTION_TYPES.SET_ROUND:
            oldState.round = payload;
            return oldState;
        case ACTION_TYPES.SET_CATEGORY:
            oldState.category = payload;
            return oldState;
        case ACTION_TYPES.SET_RANKLIST_ID:
            oldState.ranklistId = payload;
            return oldState;
        case ACTION_TYPES.END_RL_FLOW:
            return INITIAL_STATE;
        default:
            return state;
    }
}

const persistConfig = {
    key: 'root',
    storage: storage,
    stateReconciler: autoMergeLevel2, // see "Merge Process" section for details.
    // whitelist: ['rankedListState', 'category']
    blacklist: ['pairwiseComparisons'],
};
const pReducer = persistReducer(persistConfig, rootReducer);

export const store = createStore(pReducer, INITIAL_STATE, composeWithDevTools(applyMiddleware(thunk)));
export const persistor = persistStore(store);
