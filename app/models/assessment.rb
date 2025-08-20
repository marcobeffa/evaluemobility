# app/models/assessment.rb
class Assessment < ApplicationRecord
  validates :name, presence: true, if: :step_10_or_later?
  validates :age, presence: true, numericality: { greater_than: 0 }, if: :step_10_or_later?
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }, if: :step_10_or_later?
  validates :phone_number, format: { with: /\A[\d\s\-\(\)]{6,15}\z/ }, allow_blank: true, if: :step_10_or_later?
  validates :phone_country_code, presence: true, if: -> { phone_number.present? }
  validates :privacy_consent, acceptance: true, if: :step_10_or_later?

  # Exercise validations based on current step
  validates :flexion_extension, inclusion: { in: 0..3 }, if: :step_1_or_later?
  validates :arms_overhead, inclusion: { in: 0..3 }, if: :step_2_or_later?
  validates :spine_rotation_right, inclusion: { in: 0..3 }, if: :step_3_or_later?
  validates :spine_rotation_left, inclusion: { in: 0..3 }, if: :step_4_or_later?
  validates :deep_squat, inclusion: { in: 0..3 }, if: :step_5_or_later?
  validates :hands_behind_back_right, inclusion: { in: 0..3 }, if: :step_6_or_later?
  validates :hands_behind_back_left, inclusion: { in: 0..3 }, if: :step_7_or_later?
  validates :straight_leg_raise_right, inclusion: { in: 0..3 }, if: :step_8_or_later?
  validates :straight_leg_raise_left, inclusion: { in: 0..3 }, if: :step_9_or_later?

  attr_accessor :current_step

  COUNTRY_CODES = [
    { code: "+39", country: "🇮🇹 Italia", flag: "🇮🇹" },
    { code: "+41", country: "🇨🇭 Svizzera", flag: "🇨🇭" },
    { code: "+33", country: "🇫🇷 Francia", flag: "🇫🇷" },
    { code: "+49", country: "🇩🇪 Germania", flag: "🇩🇪" },
    { code: "+43", country: "🇦🇹 Austria", flag: "🇦🇹" },
    { code: "+34", country: "🇪🇸 Spagna", flag: "🇪🇸" },
    { code: "+351", country: "🇵🇹 Portogallo", flag: "🇵🇹" },
    { code: "+31", country: "🇳🇱 Paesi Bassi", flag: "🇳🇱" },
    { code: "+32", country: "🇧🇪 Belgio", flag: "🇧🇪" },
    { code: "+44", country: "🇬🇧 Regno Unito", flag: "🇬🇧" },
    { code: "+1", country: "🇺🇸 Stati Uniti", flag: "🇺🇸" },
    { code: "+1", country: "🇨🇦 Canada", flag: "🇨🇦" },
    { code: "+61", country: "🇦🇺 Australia", flag: "🇦🇺" },
    { code: "+81", country: "🇯🇵 Giappone", flag: "🇯🇵" },
    { code: "+86", country: "🇨🇳 Cina", flag: "🇨🇳" },
    { code: "+91", country: "🇮🇳 India", flag: "🇮🇳" },
    { code: "+55", country: "🇧🇷 Brasile", flag: "🇧🇷" },
    { code: "+52", country: "🇲🇽 Messico", flag: "🇲🇽" },
    { code: "+54", country: "🇦🇷 Argentina", flag: "🇦🇷" },
    { code: "+7", country: "🇷🇺 Russia", flag: "🇷🇺" }
  ].freeze

  STEPS = {
    1 => { name: "Flesso-estensione", icon: "🤸‍♂️" },
    2 => { name: "Braccia Sopra", icon: "🙆‍♂️" },
    3 => { name: "Rotazione Dx", icon: "↗️" },
    4 => { name: "Rotazione Sx", icon: "↖️" },
    5 => { name: "Squat", icon: "🏋️‍♂️" },
    6 => { name: "Mani Dietro Dx", icon: "🤲" },
    7 => { name: "Mani Dietro Sx", icon: "🤲" },
    8 => { name: "Gamba Dx", icon: "🦵" },
    9 => { name: "Gamba Sx", icon: "🦵" },
    10 => { name: "Dati Personali", icon: "👤" }
  }.freeze

  EXERCISES = {
    1 => {
      title: "Flesso-estensione in avanti (da in piedi)",
      description: "Piedi uniti, gambe tese, fletti il busto in avanti cercando di toccare il pavimento con le mani",
      field: :flexion_extension,
      criteria: {
        0 => "Mani sopra le ginocchia",
        1 => "Mani alle tibie",
        2 => "Mani alle caviglie",
        3 => "Mani a terra"
      },
      video_url: "https://www.youtube.com/embed/Dpz17mAM848?start=41"
    },
    2 => {
      title: "Braccia sopra la testa (in piedi)",
      description: "In piedi, alza entrambe le braccia sopra la testa mantenendo la schiena dritta",
      field: :arms_overhead,
      criteria: {
        0 => "Non oltre le spalle",
        1 => "Con compensi del tronco",
        2 => "Vicino alle orecchie",
        3 => "Allineate senza compensi"
      },
      video_url: "https://www.youtube.com/embed/example2"
    },
    3 => {
      title: "Rotazione globale del rachide - Destra",
      description: "In piedi, ruota il corpo verso destra mantenendo i piedi fermi",
      field: :spine_rotation_right,
      criteria: {
        0 => "Rotazione limitata",
        1 => "Ruoto 90°",
        2 => "Quasi dietro 135°",
        3 => "Ruoto completamente dietro 180°"
      },
      video_url: "https://www.youtube.com/embed/example3"
    },
    4 => {
      title: "Rotazione globale del rachide - Sinistra",
      description: "In piedi, ruota il corpo verso sinistra mantenendo i piedi fermi",
      field: :spine_rotation_left,
      criteria: {
        0 => "Rotazione limitata",
        1 => "Ruoto 90°",
        2 => "Quasi dietro 135°",
        3 => "Ruoto completamente dietro 180°"
      },
      video_url: "https://www.youtube.com/embed/example4"
    },
    5 => {
      title: "Squat profondo (a corpo libero)",
      description: "Scendi in squat il più possibile mantenendo l'equilibrio senza appoggi",
      field: :deep_squat,
      criteria: {
        0 => "Non scende",
        1 => "Instabile",
        2 => "Quasi a fondo",
        3 => "Fondo stabile"
      },
      video_url: "https://www.youtube.com/embed/example5"
    },
    6 => {
      title: "Mani dietro la schiena (destra sopra)",
      description: "Porta la mano destra dall'alto e la sinistra dal basso dietro la schiena",
      field: :hands_behind_back_right,
      criteria: {
        0 => "Distanza >20 cm",
        1 => "Distanza 10-20 cm",
        2 => "Distanza 5-10 cm",
        3 => "Le mani si toccano"
      },
      video_url: "https://www.youtube.com/embed/example6"
    },
    7 => {
      title: "Mani dietro la schiena (sinistra sopra)",
      description: "Porta la mano sinistra dall'alto e la destra dal basso dietro la schiena",
      field: :hands_behind_back_left,
      criteria: {
        0 => "Distanza >20 cm",
        1 => "Distanza 10-20 cm",
        2 => "Distanza 5-10 cm",
        3 => "Le mani si toccano"
      },
      video_url: "https://www.youtube.com/embed/example7"
    },
    8 => {
      title: "Sollevamento gamba tesa - Destra",
      description: "Sdraiato supino, solleva la gamba destra tesa il più possibile",
      field: :straight_leg_raise_right,
      criteria: {
        0 => "Meno di 45°",
        1 => "45-75°",
        2 => "75-89°",
        3 => "90° o più senza dolore"
      },
      video_url: "https://www.youtube.com/embed/example8"
    },
    9 => {
      title: "Sollevamento gamba tesa - Sinistra",
      description: "Sdraiato supino, solleva la gamba sinistra tesa il più possibile",
      field: :straight_leg_raise_left,
      criteria: {
        0 => "Meno di 45°",
        1 => "45-75°",
        2 => "75-89°",
        3 => "90° o più senza dolore"
      },
      video_url: "https://www.youtube.com/embed/example9"
    }
  }.freeze

  def full_phone_number
    return nil if phone_number.blank?
    "#{phone_country_code} #{phone_number}"
  end

  def country_flag
    return "🇮🇹" if phone_country_code.blank?
    COUNTRY_CODES.find { |c| c[:code] == phone_country_code }&.dig(:flag) || "🌍"
  end

  def total_score
    [
      flexion_extension, arms_overhead, spine_rotation_right, spine_rotation_left,
      deep_squat, hands_behind_back_right, hands_behind_back_left,
      straight_leg_raise_right, straight_leg_raise_left
    ].compact.sum
  end

  def mobility_level
    case total_score
    when 0..9
      { level: "Limitata", color: "red", description: "Mobilità limitata → consigliata valutazione individuale" }
    when 10..18
      { level: "Media", color: "yellow", description: "Mobilità media → percorso di gruppo consigliato" }
    when 19..27
      { level: "Buona", color: "green", description: "Buona mobilità → accedi a percorsi avanzati o di mantenimento" }
    end
  end

  def color_class
    case mobility_level[:color]
    when "red"
      "bg-red-100 border-red-500 text-red-800"
    when "yellow"
      "bg-yellow-100 border-yellow-500 text-yellow-800"
    when "green"
      "bg-green-100 border-green-500 text-green-800"
    end
  end

  def progress_percentage(current_step)
    ((current_step.to_f / 10) * 100).round
  end

  def completed_steps
    steps = 0
    steps += 1 if flexion_extension.present?
    steps += 1 if arms_overhead.present?
    steps += 1 if spine_rotation_right.present?
    steps += 1 if spine_rotation_left.present?
    steps += 1 if deep_squat.present?
    steps += 1 if hands_behind_back_right.present?
    steps += 1 if hands_behind_back_left.present?
    steps += 1 if straight_leg_raise_right.present?
    steps += 1 if straight_leg_raise_left.present?
    steps += 1 if name.present? && age.present? && email.present?
    steps
  end

  def is_complete?
    completed_steps == 10
  end

  private

  def step_1_or_later?
    current_step.to_i >= 1
  end

  def step_2_or_later?
    current_step.to_i >= 2
  end

  def step_3_or_later?
    current_step.to_i >= 3
  end

  def step_4_or_later?
    current_step.to_i >= 4
  end

  def step_5_or_later?
    current_step.to_i >= 5
  end

  def step_6_or_later?
    current_step.to_i >= 6
  end

  def step_7_or_later?
    current_step.to_i >= 7
  end

  def step_8_or_later?
    current_step.to_i >= 8
  end

  def step_9_or_later?
    current_step.to_i >= 9
  end

  def step_10_or_later?
    current_step.to_i >= 10
  end
end
