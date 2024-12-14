import React, { useState, useEffect } from "react";
import { useParams } from "react-router";

import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import { faSpinner } from "@fortawesome/free-solid-svg-icons";

const TRACK_QUERY_TEMPLATE =
  "https://itunes.apple.com/lookup?id={collectionId}&limit=50&entity=song";

export default function TrackList({ setAlertMessage }) {
  const [trackData, setTrackData] = useState([]);
  const [isQuerying, setIsQuerying] = useState(false);
  const [previewAudio, setPreviewAudio] = useState(null);
  const { collectionId } = useParams();

  useEffect(() => {
    setAlertMessage(null);
    setIsQuerying(true);
    const queryUrl = TRACK_QUERY_TEMPLATE.replace(
      "{collectionId}",
      collectionId
    );

    fetch(queryUrl)
      .then((response) => response.json())
      .then((data) => {
        setIsQuerying(false);
        const tracks = data.results.slice(1);
        if (tracks.length === 0) {
          setAlertMessage("No tracks found for album.");
        } else {
          setTrackData(tracks);
        }
      })
      .catch((error) => {
        setIsQuerying(false);
        setAlertMessage(error.message);
      });
  }, [collectionId, setAlertMessage]);

  const togglePlayingPreview = (previewUrl) => {
    if (!previewAudio) {
      const newPreview = new Audio(previewUrl);
      newPreview.addEventListener("ended", () => setPreviewAudio(null));
      setPreviewAudio(newPreview);
      newPreview.play();
    } else {
      previewAudio.pause();
      setPreviewAudio(null);
    }
  };

  trackData.sort((trackA, trackB) => trackA.trackNumber - trackB.trackNumber);

  const trackElemArray = trackData.map((track) => {
    let classList = "track-record";
    if (previewAudio && previewAudio.src === track.previewUrl) {
      classList += " fa-spin";
    }

    return (
      <div key={track.trackId}>
        <div
          role="button"
          className={classList}
          onClick={() => togglePlayingPreview(track.previewUrl)}
        >
          <p className="track-name">{track.trackName}</p>
          <p className="track-artist">({track.artistName})</p>
        </div>
        <p className="text-center">Track {track.trackNumber}</p>
      </div>
    );
  });

  return (
    <div>
      {isQuerying && (
        <FontAwesomeIcon
          icon={faSpinner}
          spin
          size="4x"
          aria-label="Loading..."
          aria-hidden="false"
        />
      )}
      <div className="d-flex flex-wrap">{trackElemArray}</div>
    </div>
  );
}
