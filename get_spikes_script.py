from pathlib import Path

import numpy as np
import tqdm
from radiens.utils.enums import SignalType
from radiens.utils.util import dset_to_ntv_dict, make_time_range
from radiens.videre_client import VidereClient
from scipy.io import savemat

names = [ "MKO03_05","MKO03_06","MKO03_07","MKO03_08","MKO03_09","MKO03_10", "MKO03_11"]
for name in names:
    # set paths
    data_path = "D:\Spike_CSD_Analysis\Data" #~/radix/data
    cont_data_bname = name + "_Spikes"
    spike_data_bname = name + "_Spikes_s0"
    spike_data_save_fname = spike_data_bname + ".mat"
    spike_data_save_fpath = Path(
        data_path, spike_data_save_fname).expanduser().resolve()


    cont_data_path = Path(data_path,       cont_data_bname).expanduser().resolve()
    spike_data_save_path = Path(data_path, spike_data_bname).expanduser().resolve()

    # Create a VidereClient object
    vc = VidereClient()

    # link the client to continuous data
    cont_meta = vc.link_data_file(cont_data_path, calc_metrics=False, force=False)


    # get channel mapping
    chan_idxs = cont_meta.channel_metadata.index(SignalType.AMP)
    dset_to_ntv = dset_to_ntv_dict(chan_idxs)

    file_dur = cont_meta.time_range.sec[1] - cont_meta.time_range.sec[0]
    chunk_size_sec = 1
    file_pos_sec = cont_meta.time_range.sec[0]

    timestamps = np.array([], dtype=np.float64)
    labels = np.array([], dtype=np.int32)
    ntv_idxs = np.array([], dtype=np.int32)
    print(
        f"Getting spikes from file {cont_data_bname} with time range {cont_meta.time_range.sec[0]} - {cont_meta.time_range.sec[1]} seconds")
    while file_pos_sec < cont_meta.time_range.sec[1]:
        tr = make_time_range(
            time_range=[file_pos_sec, file_pos_sec + chunk_size_sec], fs=cont_meta.TR.fs)
        file_pos_sec += chunk_size_sec

        # get spikes
        spike_timestamps = vc.spikes().get_spike_timestamps(
            spike_data_bname, time_range=tr)

        # timestamps
        ts_sec = np.array(list(map(lambda x: x/cont_meta.TR.fs,
                            spike_timestamps["timestamps"])), dtype=np.float64)  # convert to seconds
        timestamps = np.concatenate((timestamps, ts_sec))

        # labels
        labels = np.concatenate((labels, spike_timestamps["labels"]))

        # ntv idxs
        dset_idxs = spike_timestamps["dset_idxs"]
        new_ntv_idxs = np.array([dset_to_ntv[dset_idx]
                                for dset_idx in dset_idxs], dtype=np.int32)
        ntv_idxs = np.concatenate((ntv_idxs, new_ntv_idxs))


    print(f"Saving spike data to {spike_data_save_fpath}")
    # save the spike timestamps
    savemat(spike_data_save_fpath, {
        "timestamps": timestamps,
        "labels": labels,
        "ntvIdxs": ntv_idxs,
    }, oned_as="column")

    print("Done!")
